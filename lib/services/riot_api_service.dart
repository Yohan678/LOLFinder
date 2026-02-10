import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

//import models
import '../models/player_data.dart';
import '../models/champion_name.dart';
import '../models/summoner.dart';


class RiotApiService {
  
  Future<List<ChampionName>> fetchChampionNameEX(String userName, String userTag) async {
    final accountResponse = await http.get(Uri.parse('https://americas.api.riotgames.com/riot/account/v1/accounts/by-riot-id/$userName/$userTag?api_key=${dotenv.env['API_KEY']}'),
    );

    if (accountResponse.statusCode != 200) {
      throw Exception('Failed to load account data: ${accountResponse.statusCode}');
    }

    final playerData = PlayerData.fromJson(jsonDecode(accountResponse.body));
    final playerUniqueId = playerData.puuid;

    final matchResponse = await http.get(Uri.parse('https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/$playerUniqueId/ids?start=0&count=20&api_key=${dotenv.env['API_KEY']}'),
    );


    if (matchResponse.statusCode != 200) {
      throw Exception('Failed to load match IDs: ${matchResponse.statusCode}');
    }

    final List<dynamic> matchIds = jsonDecode(matchResponse.body);
    
    final List<ChampionName> matchData = [];

    for (int i = 0; i < matchIds.length; i++ ) {
      final matchdetailresponseEx = await http.get(Uri.parse('https://americas.api.riotgames.com/lol/match/v5/matches/${matchIds[i]}?api_key=${dotenv.env['API_KEY']}'));

      if (matchdetailresponseEx.statusCode == 200) {
        final matchdetailjsonEx = jsonDecode(matchdetailresponseEx.body);
        final participants = matchdetailjsonEx['info']['participants'] as List<dynamic>;
        final queueId = matchdetailjsonEx['info']['queueId'];

        for (var participant in participants) {
          if (participant['puuid'] == playerUniqueId) {
            final championName = participant['championName'];
            final kills = participant['kills'];
            final deaths = participant['deaths'];
            final assists = participant['assists'];
            final win = participant['win'];
            var champ = ChampionName(championName: championName, kills: kills, deaths: deaths, assists: assists, win: win, queueId: queueId);
            matchData.add(champ);
          }
        }
      }
    }
    return matchData;
  }

  Future<Summoner> fetchSummonerIconId(String userName, String userTag) async {
    final accountResponse = await http.get(Uri.parse('https://americas.api.riotgames.com/riot/account/v1/accounts/by-riot-id/$userName/$userTag?api_key=${dotenv.env['API_KEY']}'),);

    if (accountResponse.statusCode != 200) {
      throw Exception('Failed to load account data: ${accountResponse.statusCode}');
    }

    final playerData = PlayerData.fromJson(jsonDecode(accountResponse.body));
    final playerUniqueId = playerData.puuid;

    final summonerResponse = await http.get(Uri.parse('https://americas.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/$playerUniqueId'));

    if (summonerResponse.statusCode == 200) {
      final summonerInfo = jsonDecode(summonerResponse.body);
      final profileIconId = summonerInfo['profileIconId'];
      var summonerId = Summoner(profileIconId: profileIconId);
      return summonerId;
    } else {
      throw Exception('Failed to find summoner data: ${summonerResponse.statusCode}');
    }


  }
}

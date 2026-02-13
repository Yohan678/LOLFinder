import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

//import models
import '../models/champion_name.dart';
import '../models/summoner.dart';
import '../models/combined_data.dart';


class RiotApiService {
  Future<CombinedData> fetchCombinedData(String userName, String userTag) async {
    try {// === Account Data - Account V1 ===
    final accountResponse = await http.get(Uri.parse('https://americas.api.riotgames.com/riot/account/v1/accounts/by-riot-id/$userName/$userTag?api_key=${dotenv.env['API_KEY']}'));

    if (accountResponse.statusCode != 200) throw Exception('Failed to load account data: ${accountResponse.statusCode}');

    final accountData = jsonDecode(accountResponse.body);
    final String puuid = accountData['puuid'];

    // === Match ID Data - Match V5 ===
    final matchIdResponse = await http.get(Uri.parse('https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/$puuid/ids?start=0&count=20&api_key=${dotenv.env['API_KEY']}'));

    if (matchIdResponse.statusCode != 200) throw Exception('Failed to load match id data: ${matchIdResponse.statusCode}');
    
    final List<dynamic> matchIdsData = jsonDecode(matchIdResponse.body);
    final List<ChampionName> matchDataList = [];

    for (int i = 0; i < matchIdsData.length; i++) {
      final matchDetailReponse = await http.get(Uri.parse('https://americas.api.riotgames.com/lol/match/v5/matches/${matchIdsData[i]}?api_key=${dotenv.env['API_KEY']}'));

      if (matchDetailReponse.statusCode == 200) {
        final matchDetailJson = jsonDecode(matchDetailReponse.body);
        final participants = matchDetailJson['info']['participants'] as List<dynamic>;
        final queueId = matchDetailJson['info']['queueId'];
        print("Duration Check: ${matchDetailJson['info']?['gameDuration']}");
        final gameDuration = matchDetailJson['info']?['gameDuration'];
        final gameEndTimeStamp = matchDetailJson['info']?['gameEndTimestamp'];

        for (var participant in participants) {
          if (participant['puuid'] == puuid) {
            final championName = participant['championName'];
            final kills = participant['kills'];
            final deaths = participant['deaths'];
            final assists = participant['assists'];
            final win = participant['win'];
            var champ = ChampionName(
              championName: championName, 
              kills: kills, 
              deaths: deaths, 
              assists: assists, 
              win: win, 
              queueId: queueId,
              gameDuration: gameDuration,
              gameEndTimeStamp: gameEndTimeStamp,
              );
            matchDataList.add(champ);
          }
        }
      }
    }

    // === Summoner Data - Summoner V4 ===
    final summonerResponse = await http.get(Uri.parse('https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/$puuid?api_key=${dotenv.env['API_KEY']}'));
    final summonerData = Summoner.fromJson(jsonDecode(summonerResponse.body));

    return CombinedData(
      accountData: accountData, 
      matchData: matchDataList, 
      summonerData: summonerData
    );

    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  } 

}

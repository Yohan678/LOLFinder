import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

//import models
import '../models/player_data.dart';
import '../models/match_id.dart';
import '../models/champion_name.dart';


class RiotApiService {
  Future<PlayerData> fetchPlayerData(String userName, String userTag) async { 
    final response = await http.get(Uri.parse('https://americas.api.riotgames.com/riot/account/v1/accounts/by-riot-id/$userName/$userTag?api_key=${dotenv.env['API_KEY']}'),
    );

    if (response.statusCode == 200) {
      return PlayerData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<MatchId> fetchMatchIds(String puuid) async {
    final response = await http.get(Uri.parse('https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/$puuid/ids?start=0&count=20&api_key=${dotenv.env['API_KEY']}'),
    );

    if (response.statusCode == 200) {
      return MatchId.fromJson(jsonDecode(response.body));
    } else  {
      throw Exception('Failed to load match IDs: ${response.statusCode}');
    }
  }

  Future<MatchId> fetchMatchIdExample(String userName, String userTag) async {
    final accountResponse = await http.get(Uri.parse('https://americas.api.riotgames.com/riot/account/v1/accounts/by-riot-id/$userName/$userTag?api_key=${dotenv.env['API_KEY']}'),
    );

    if (accountResponse.statusCode != 200) {
      throw Exception('Failed to load account data: ${accountResponse.statusCode}');
    }

    final playerData = PlayerData.fromJson(jsonDecode(accountResponse.body));
    final playerUniqueId = playerData.puuid;

    final matchResponse = await http.get(Uri.parse('https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/$playerUniqueId/ids?start=0&count=20&api_key=${dotenv.env['API_KEY']}'),
    );

    if (matchResponse.statusCode == 200) {
      print(matchResponse.body);
      final List<dynamic> jsonresponse = jsonDecode(matchResponse.body);

      return MatchId(listMatch: jsonresponse.cast<String>());
    } else {
      throw Exception('Failed to load match IDs: ${matchResponse.statusCode}');
    }
  }

  Future<ChampionName> fetchChampionNameEX(String userName, String userTag) async {
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
    final firstMatchID = matchIds[0];
    print(matchIds[0]);

    final matchDetailResponse = await http.get(Uri.parse('https://americas.api.riotgames.com/lol/match/v5/matches/$firstMatchID?api_key=${dotenv.env['API_KEY']}'));

    if (matchDetailResponse.statusCode == 200) {
      final matchDetailJson = jsonDecode(matchDetailResponse.body);
      final participants = matchDetailJson['info']['participants'] as List<dynamic>;

      for (var participant in participants) {
        if (participant['puuid'] == playerUniqueId) {
          final championName = participant['championName'];
          final kills = participant['kills'];
          final deaths = participant['deaths'];
          final assists = participant['assists'];
          final win = participant['win'];
          print('champion name: $championName, kills: $kills, deaths: $deaths, assists: $assists');
          return ChampionName(
            championName: championName,
            kills: kills,
            deaths: deaths,
            assists: assists,
            win: win,
          );
        }
      }
      throw Exception('Champion not found for the player in the match.');
    } else {
      throw Exception('Failed to load match details: ${matchDetailResponse.statusCode}');
    }
  }
}
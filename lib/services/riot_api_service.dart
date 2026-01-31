import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

//import models
import '../models/player_data.dart';
import '../models/match_id.dart';


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
}
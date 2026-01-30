import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/player_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
}
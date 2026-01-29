import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

//Fetch data from API
Future<PlayerData> fetchPlayerData(String userName, String userTag) async {
    final response = await http.get(
      Uri.parse(
        'https://americas.api.riotgames.com/riot/account/v1/accounts/by-riot-id/${userName}/${userTag}?api_key=${dotenv.env['API_KEY']}',
      ),
    );

    if (response.statusCode == 200) {
      return PlayerData.fromJson(jsonDecode(response.body));;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

class PlayerData {
  final String puuid;
  final String gameName;
  final String tagLine;

  const PlayerData({
    required this.puuid,
    required this.gameName,
    required this.tagLine,
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      puuid: json['puuid'] ?? '',
      gameName: json['gameName'] ?? '',
      tagLine: json['tagLine'] ?? '',
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //use this controller to get what user typed
  final _nameTextController = TextEditingController(); //UN = UserName
  final _tagTextController = TextEditingController(); //UT = UserTag

  //Variable to store fetched player data
  Future<PlayerData>? _playerDataFuture;

  //Store user input into variables
  String userName = '';
  String userTag = '';
  String puuid = '';

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text("Find your LOL profiles!"),
        ),

        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // === Text Display Example ===
              Expanded(
                child: Center(
                  //FutureBuilder to handle async data fetching
                  child: FutureBuilder<PlayerData> (
                    future: _playerDataFuture,
                    builder: (context, snapshot) {
                      //if user did not search yet
                      if (_playerDataFuture == null) {
                        return Text('Search for a player!', style: TextStyle(fontSize: 24));
                      }

                      //if still loading for the data
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      //if data is fetched successfully
                      if (snapshot.hasData) {
                        final playerData = snapshot.data!;
                        return Text(
                          'User name is ${playerData.gameName} \nTag is ${playerData.tagLine} \nPUUID is ${playerData.puuid}',
                          style: TextStyle(fontSize: 30),
                        );
                      }

                      //if there is error
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      //default value
                      return Text('No data');
                    }
                  )
                )
              ),

              // === Title Display ===
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Search Your PlayerName#Tag",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // === Username Text Input ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: screenWidth / 2,
                      child: TextField(
                        autocorrect: false,
                        controller: _nameTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your user name',
                        ),
                      ),
                    ),
                  ),

                  Text("#"),

                  // === Tag TextInput ====
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 100,
                      child: TextField(
                        autocorrect: false,
                        controller: _tagTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'NA1',
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // === Search Button ===
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MaterialButton(
                  color: Colors.blue,
                  child: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _playerDataFuture = fetchPlayerData(
                        _nameTextController.text,
                        _tagTextController.text
                      );
                    });
                  }
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

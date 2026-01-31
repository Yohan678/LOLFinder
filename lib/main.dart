import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/player_data.dart';
import '../models/match_id.dart';
import '../services/riot_api_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  RiotApiService riotApiService = RiotApiService();

  //use this controller to get what user typed
  final _nameTextController = TextEditingController(); //UN = UserName
  final _tagTextController = TextEditingController(); //UT = UserTag

  //Variable to store fetched player data
  Future<PlayerData>? _playerDataFuture;
  Future<MatchId>? _matchIdFuture;

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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              CachedNetworkImage(imageUrl: "https://ddragon.leagueoflegends.com/cdn/14.3.1/img/champion/Aatrox.png", 
              placeholder:(context, url) => CircularProgressIndicator()),
              
              // === Text Display Example ===
              Expanded(
                child: Center(
                  //FutureBuilder to handle async data fetching
                  child: FutureBuilder<MatchId> (
                    future: _matchIdFuture,
                    builder: (context, snapshot) {
                      //if user did not search yet
                      if (_matchIdFuture == null) {
                        return Text('Search for a player!', style: TextStyle(fontSize: 24));
                      }

                      //if still loading for the data
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      //if data is fetched successfully
                      if (snapshot.hasData) {
                        final matchId = snapshot.data!;
                        return Text(
                          'Recent Match ID: ${matchId.listMatch.isNotEmpty ? matchId.listMatch[0] : "No matches found"}',
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
                      _matchIdFuture = riotApiService.fetchMatchIdExample(
                        _nameTextController.text, _tagTextController.text);
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

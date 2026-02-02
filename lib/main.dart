import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lol_finder/screens/main_appbar.dart';
// import '../models/player_data.dart';
// import '../../models/match_id.dart';
import '../services/riot_api_service.dart';
import '../models/champion_name.dart'; 


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
  // Future<PlayerData>? _playerDataFuture;
  // Future<MatchId>? _matchIdFuture;
  Future<List<ChampionName>>? _championNameFuture;


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
          elevation: 50,
          backgroundColor: Color.fromARGB(255, 19, 36, 64),
          title: Text("Find summoner's recent games",
          style: TextStyle(color: Colors.white)),
        ),

        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              // === Text Display Example ===
              Expanded(
                child: Center(
                  //FutureBuilder to handle async data fetching
                  child: FutureBuilder<List<ChampionName>> (
                    future: _championNameFuture,
                    builder: (context, snapshot) {
                      //if user did not search yet
                      if (_championNameFuture == null) {
                        return Text('Search for a player!', style: TextStyle(fontSize: 24));
                      }

                      //if still loading for the data
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      //if data is fetched successfully
                      if (snapshot.hasData) {
                        final List<ChampionName> data = snapshot.data!;
                        if (data.isEmpty) {
                          return Text('zero data found');
                        }

                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder:  (context, index) {
                            final game = data[index];
                            return Container(
                              margin: const EdgeInsets.all(10),
                              height: 100,
                              decoration: BoxDecoration(
                                color: game.win ? Color.fromARGB(180, 255, 52, 52) : Color.fromARGB(180, 66, 99, 245),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CachedNetworkImage(imageUrl: 'https://ddragon.leagueoflegends.com/cdn/16.2.1/img/champion/${game.championName}.png'),
                                  ),
                                  
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(game.championName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

                                      Text('${game.kills}/${game.deaths}/${game.assists}')
                                    ]
                                  )
                                ]
                              )
                             );
                          }
                          
                          );
                      }

                      //if there is error
                      if (snapshot.hasError) {
                        return Text('Error: this is${snapshot.error}');
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
                      _championNameFuture = riotApiService.fetchChampionNameEX(
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

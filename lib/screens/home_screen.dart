import 'package:flutter/material.dart';
import 'package:lol_finder/services/riot_api_service.dart';
import 'package:lol_finder/models/champion_name.dart';
import 'package:lol_finder/models/summoner.dart';
import 'package:lol_finder/widgets/profile_card.dart';
import 'package:lol_finder/widgets/match_card.dart';
import 'package:lol_finder/widgets/player_search_form.dart';
import 'package:lol_finder/models/combined_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RiotApiService _riotApiService = RiotApiService();

  //use this controller to get what user typed
  final _nameTextController = TextEditingController();
  final _tagTextController = TextEditingController();

  //Variable to store fetched player data
  Future<CombinedData>? _combinedDataFuture;

  void _onSearch() {
    setState(() {
      _combinedDataFuture = _riotApiService.fetchCombinedData(_nameTextController.text, _tagTextController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(200, 19, 36, 64),
      appBar: AppBar(
        title: Text("Summoner's History"),
        backgroundColor: Color.fromARGB(255, 19, 36, 64),
        foregroundColor: Colors.white,
      ),

      body: Padding (
        padding: const EdgeInsetsGeometry.all(10),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // === Results Displaying Section ===
            Expanded (
              child: Center(
                child: FutureBuilder<CombinedData> (
                  future: _combinedDataFuture,
                  builder: (context, snapshot) {
                    //User not searched yet
                    if (_combinedDataFuture == null) return Text('Search for a summoner!', style: TextStyle(fontSize: 24));
                    //Data Loading
                    if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
                    //Error
                    if (snapshot.hasError) return Text('Error: ${snapshot.error}');

                    // === Successfully fetched data ===
                    if (snapshot.hasData) {
                      final Summoner summonerData = snapshot.data!.summonerData;
                      final List<ChampionName> matchDataList = snapshot.data!.matchData;

                      // === Recent Match List View ===
                      if(matchDataList.isEmpty) return Text('zero data found');

                      return Column(
                        children: [
                          ProfileCard(
                            summoner: summonerData,
                            userName: _nameTextController.text,
                            userTag: _tagTextController.text,
                          ),

                          Expanded(
                            child: ListView.builder(
                              itemCount: matchDataList.length,
                              itemBuilder: (context, index) {
                                return MatchCard(game: matchDataList[index]);
                              }
                            )
                          )
                        ]
                      );
                    }
                    //Default Value
                    return Text('No Data Found');
                  }  
                )
              )
            ),

            PlayerSearchForm(
              nameController: _nameTextController,
              tagController: _tagTextController, 
              onSearch: _onSearch
            ),
          ]
        )
      )
    );
  }
}
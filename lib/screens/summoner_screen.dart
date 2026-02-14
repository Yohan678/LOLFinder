import 'package:flutter/material.dart';

import 'package:lol_finder/services/riot_api_service.dart';
import 'package:lol_finder/models/summoner.dart';
import 'package:lol_finder/models/combined_data.dart';
import 'package:lol_finder/models/champion_name.dart';

import 'package:lol_finder/widgets/profile_card.dart';
import 'package:lol_finder/widgets/match_card.dart';

class SummonerScreen extends StatefulWidget {
  final String userName;
  final String userTag;

  const SummonerScreen({
    super.key,
    required this.userName,
    required this.userTag,
  });

  @override
  State<SummonerScreen> createState() => _SummonerScreenState();
}

class _SummonerScreenState extends State<SummonerScreen> {
  Future<CombinedData>? _combinedDataFuture;

  //Initialize when screen is on
  //Fetch data when navigator push this screen

  @override
  void initState() {
    super.initState();
    _combinedDataFuture = RiotApiService().fetchCombinedData(widget.userName, widget.userTag);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        title: Text("Summoner's History"),
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back)
        )
      ),

      body: Padding(
        padding: const EdgeInsetsGeometry.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Expanded(
              child: FutureBuilder<CombinedData> (
                future: _combinedDataFuture,
                builder: (context, snapshot) {
                  if (_combinedDataFuture == null) return Text('Search for a summoner!', style: TextStyle(fontSize: 24, color: Color(0xFFF1F5F9)));
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        )
                      ),
                    );
                  }
                  if (snapshot.hasError) return Text('Error: ${snapshot.error}');

                  if (snapshot.hasData) {
                      final Summoner summonerData = snapshot.data!.summonerData;
                      final List<ChampionName> matchDataList = snapshot.data!.matchData;

                      // === Recent Match List View ===
                      if(matchDataList.isEmpty) return Text('zero data found');

                      return Column(
                        children: [
                          ProfileCard(
                            summoner: summonerData,
                            userName: widget.userName,
                            userTag: widget.userTag,
                            summonerLevel: summonerData.summonerLevel,
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

                    return Text('No Data Found');
                }
              )
            )
          ]
        )
      )
    );
  }
}
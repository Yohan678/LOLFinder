import 'package:flutter/material.dart';
import 'package:lol_finder/services/riot_api_service.dart';
import 'package:lol_finder/models/champion_name.dart';
import 'package:lol_finder/widgets/match_card.dart';
import 'package:lol_finder/widgets/player_search_form.dart';

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
  Future<List<ChampionName>>? _championNameFuture;

  void _onSearch() {
    setState(() {
      _championNameFuture = _riotApiService.fetchChampionNameEX(_nameTextController.text, _tagTextController.text);
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
                child: FutureBuilder<List<ChampionName>> (
                  future: _championNameFuture,
                  builder: (context, snapshot) {
                    
                    //User not searched yet
                    if (_championNameFuture == null) return Text('Search for a summoner!', style: TextStyle(fontSize: 24));

                    //Data Loading
                    if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();

                    //Error
                    if (snapshot.hasError) return Text('Error: ${snapshot.error}');

                    //Successfully fetched data
                    if (snapshot.hasData) {
                      final List<ChampionName> data = snapshot.data!;
                      if(data.isEmpty) return Text('zero data found');

                      return ListView.builder (
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return MatchCard(game: data[index]);
                        }
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
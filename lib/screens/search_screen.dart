import 'package:flutter/material.dart';
import 'package:lol_finder/screens/summoner_screen.dart';

import 'package:lol_finder/widgets/player_search_form.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _nameTextController = TextEditingController();
  final _tagTextController = TextEditingController();

  void _onSearch() {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => SummonerScreen(userName: _nameTextController.text, userTag: _tagTextController.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        title: Text("Search for a Summoner!"),
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),

      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayerSearchForm(
              nameController: _nameTextController, 
              tagController: _tagTextController, 
              onSearch: _onSearch
            ),
          ]
        )
    );
  }
}
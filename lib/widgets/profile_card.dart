import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lol_finder/models/summoner.dart';

class ProfileCard extends StatelessWidget {
  final Summoner summoner;
  final String userName;
  final String userTag;
  final int summonerLevel;

  const ProfileCard({
    super.key, 
    required this.summoner,
    required this.userName,
    required this.userTag,
    required this.summonerLevel
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3.0),
      height: 150,
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10)
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.all(10), //DDragon url needed to be changed
          child: CachedNetworkImage(imageUrl: 'https://ddragon.leagueoflegends.com/cdn/16.2.1/img/profileicon/${summoner.profileIconId}.png',
          errorWidget: (context, url, error) => Icon(Icons.error),)
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LV $summonerLevel',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: Color(0xFFF1F5F9))
                ),
                Text(userName,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF1F5F9))),

                Text(userTag,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200, color: Color(0xFF94A3B8))),
              ]
            )
          )

        ]
      )
    );
  }
}
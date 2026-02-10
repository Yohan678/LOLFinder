import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lol_finder/models/summoner.dart';

class ProfileCard extends StatelessWidget {
  final Summoner summoner;
  const ProfileCard({super.key, required this.summoner});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3.0),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10)
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.all(10), //DDragon url needed to be changed
          child: CachedNetworkImage(imageUrl: 'https://ddragon.leagueoflegends.com/cdn/16.2.1/img/icon/${summoner.profileIconId}.png',
          errorWidget: (context, url, error) => Icon(Icons.error),)
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text()
              ]
            )
          )

        ]
      )
    );
  }
}
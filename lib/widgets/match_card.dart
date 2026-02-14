import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lol_finder/models/champion_name.dart';

import 'package:intl/intl.dart';

class MatchCard extends StatelessWidget {
  final ChampionName game;

  const MatchCard({super.key, required this.game});

  String _getQueueType(int queueId) {
    return switch (queueId) {
      420 => 'SOLO RANKED',
      440 => 'FLEX RANKED',
      490 => 'NORMAL',
      400 => 'NORMAL (BLIND)',
      450 => 'ARAM',
      1700 => 'ARENA',
      _ => 'Unknown Game Mode'
    };
  }

  String _formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy/MM/dd");
    final gameEndTimeStampDate = DateTime.fromMillisecondsSinceEpoch(game.gameEndTimeStamp);
    String convertedEndTime = dateFormat.format(gameEndTimeStampDate);
    
    return Container(
      margin: EdgeInsets.all(3.0),
      height: 100,
      decoration: BoxDecoration(
        color: game.win ? Color(0xFF1E40AF) : Color(0xFF7F1D1D),
        borderRadius: BorderRadius.circular(15)
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CachedNetworkImage(imageUrl: 'https://ddragon.leagueoflegends.com/cdn/16.2.1/img/champion/${game.championName}.png',
            errorWidget: (context, url, error) => Icon(Icons.error),),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(game.championName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFF1F5F9))),

                Text(
                  '${game.kills}/${game.deaths}/${game.assists}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color(0xFFF1F5F9))
                ),

                Text(
                  _getQueueType(game.queueId),
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w300, color: Color(0xFF94A3B8)),
                )

              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  _formatDuration(game.gameDuration),
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w200)
                ),

                Text(
                  convertedEndTime,
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 8, fontWeight: FontWeight.w200)
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
//Match Detail Informations
class ChampionName {
  final String championName;
  final int kills;
  final int deaths;
  final int assists;
  final bool win;
  final int queueId;
  final int gameDuration;
  final int gameEndTimeStamp;

  const ChampionName({
    required this.championName, 
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.win,
    required this.queueId,
    required this.gameDuration,
    required this.gameEndTimeStamp
  });

  factory ChampionName.fromJson(Map<String, dynamic> json) {
    return ChampionName(
      championName: json['championName'] ?? '',
      kills: json['kills'] as int,
      deaths: json['deaths'] as int,
      assists: json['assists'] as int,
      win: json['win'],
      queueId: json['queueId'] ?? 0,
      gameDuration: json['gameDuration'] ?? 0,
      gameEndTimeStamp: json['gameEndTimeStamp'] ?? 0,
    );
  }
}
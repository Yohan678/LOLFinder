class ChampionName {
  final String championName;
  final int kills;
  final int deaths;
  final int assists;
  final bool win;
  final int queueId;

  const ChampionName({
    required this.championName, 
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.win,
    required this.queueId,
  });

  factory ChampionName.fromJson(Map<String, dynamic> json) {
    return ChampionName(
      championName: json['championName'] ?? '',
      kills: json['kills'] as int,
      deaths: json['deaths'] as int,
      assists: json['assists'] as int,
      win: json['win'],
      queueId: json['queueId'] ?? 0,
    );
  }
}
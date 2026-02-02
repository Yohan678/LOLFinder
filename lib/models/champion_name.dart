class ChampionName {
  final String championName;
  final int kills;
  final int deaths;
  final int assists;
  final bool win;

  const ChampionName({
    required this.championName, 
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.win,
  });

  factory ChampionName.fromJson(Map<String, dynamic> json) {
    return ChampionName(
      championName: json['championName'] ?? '',
      kills: json['kills'] as int,
      deaths: json['deaths'] as int,
      assists: json['assists'] as int,
      win: json['win'],
    );
  }
}
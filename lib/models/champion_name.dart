class ChampionName {
  final String championName;

  const ChampionName({
    required this.championName,
  });

  factory ChampionName.fromJson(Map<String, dynamic> json) {
    return ChampionName(
      championName: json['championName'] ?? '',
    );
  }
}
class PlayerData {
  final String puuid;
  final String gameName;
  final String tagLine;

  const PlayerData({
    required this.puuid,
    required this.gameName,
    required this.tagLine,
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      puuid: json['puuid'],
      gameName: json['gameName'],
      tagLine: json['tagLine'],
    );
  }
}
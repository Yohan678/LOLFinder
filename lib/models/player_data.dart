class PlayerData {
  final String puuid;

  const PlayerData({
    required this.puuid,
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      puuid: json['puuid'] ?? '',
    );
  }
}
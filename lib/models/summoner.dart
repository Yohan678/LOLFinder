class Summoner {
  final int profileIconId;
  final int summonerLevel;

  const Summoner({
    required this.profileIconId,
    required this.summonerLevel
  });

  factory Summoner.fromJson(Map<String, dynamic> json) {
    return Summoner(
      profileIconId: json['profileIconId'],
      summonerLevel: json['summonerLevel'],
    );
  }
}
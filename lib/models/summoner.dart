class Summoner {
  final int profileIconId;

  const Summoner({
    required this.profileIconId,
  });

  factory Summoner.fromJson(Map<String, dynamic> json) {
    return Summoner(
      profileIconId: json['profileIconId'],
    );
  }
}
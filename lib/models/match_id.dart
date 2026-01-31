class MatchId {
  final List<String> listMatch;

  const MatchId({
    required this.listMatch,
  });

  factory MatchId.fromJson(Map<String, dynamic> json) {
    return MatchId(
      listMatch: List<String>.from(json['listMatch'] ?? []),
    );
  }
}
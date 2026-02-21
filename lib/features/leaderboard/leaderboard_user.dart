class LeaderboardUser {
  final int id;
  final String name;
  final int points;
  final String? image;
  final String wilaya;

  LeaderboardUser({
    required this.id,
    required this.name,
    required this.points,
    required this.image,
    required this.wilaya,
  });

  factory LeaderboardUser.fromMap(Map<String, dynamic> json) {
    return LeaderboardUser(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String,
        points: json['points'] as int,
        image: json['image'] == null
            ? json['avatar_url'] as String?
            : json['image'] as String?,
        wilaya: json['wilaya'] as String);
  }

  // get image if https://tayssir-bac.com/storage/ then return null
  String? get prodImage =>
      image == 'https://tayssir-bac.com/storage/' ? null : image;
}

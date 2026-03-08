import 'package:tayssir/providers/user/badge_model.dart';

class LeaderboardUser {
  final int id;
  final String name;
  final int points;
  final String? image;
  final String wilaya;
  final BadgeModel? badge;

  LeaderboardUser({
    required this.id,
    required this.name,
    required this.points,
    required this.image,
    required this.wilaya,
    this.badge,
  });

  factory LeaderboardUser.fromMap(Map<String, dynamic> json) {
    return LeaderboardUser(
        id: json['id'] as int? ?? 0,
        name: (json['name'] ?? json['username'] ?? 'مستخدم') as String,
        points: (json['points'] ?? 0) as int,
        image: json['image'] == null
            ? json['avatar_url'] as String?
            : json['image'] as String?,
        wilaya: (json['wilaya'] ?? 'الجزائر') as String,
        badge: json['badge'] == null
            ? null
            : BadgeModel.fromMap(json['badge'] as Map<String, dynamic>));
  }

  // get image if https://tayssir-bac.com/storage/ then return null
  String? get prodImage =>
      image == 'https://tayssir-bac.com/storage/' ? null : image;
}

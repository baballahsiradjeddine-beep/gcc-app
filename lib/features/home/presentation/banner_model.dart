class BannerModel {
  final int id;
  final String? title;
  final String? description;
  final String actionUrl;
  final String actionLabel;
  final String gradientStart;
  final String gradientEnd;
  final String? image;
  final String createdAt;

  const BannerModel({
    required this.id,
    this.title,
    this.description,
    required this.actionUrl,
    required this.actionLabel,
    required this.gradientStart,
    required this.gradientEnd,
    this.image,
    required this.createdAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      actionUrl: json['action_url'] ?? '',
      actionLabel: json['action_label'] ?? '',
      gradientStart: json['gradient_start'],
      gradientEnd: json['gradient_end'],
      image: json['image'],
      createdAt: json['created_at'],
    );
  }
}

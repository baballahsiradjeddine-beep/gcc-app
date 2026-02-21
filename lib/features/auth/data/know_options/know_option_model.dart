class KnowOptionModel {
  final int id;
  final String name;
  final String icon;

  KnowOptionModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory KnowOptionModel.fromJson(Map<String, dynamic> json) {
    return KnowOptionModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}

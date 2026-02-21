class TopicModel {
  final int id;
  final String name;
  final String color;
  final String secondaryColor;

  TopicModel({
    required this.id,
    required this.name,
    required this.color,
    required this.secondaryColor,
  });

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      color: map['color'] ?? '',
      secondaryColor: map['secondary_color'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'secondary_color': secondaryColor,
    };
  }
}

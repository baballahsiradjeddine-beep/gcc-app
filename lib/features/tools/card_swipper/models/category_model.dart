class CategoryModel {
  final int id;
  final int topicId;
  final String name;

  CategoryModel({
    required this.id,
    required this.topicId,
    required this.name,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? 0,
      topicId: map['topic_id'] ?? 0,
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic_id': topicId,
      'name': name,
    };
  }
}

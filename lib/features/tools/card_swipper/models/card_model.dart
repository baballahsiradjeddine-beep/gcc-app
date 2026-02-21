class CardModel {
  final int id;
  final int categoryId;
  final String name;
  final String description;

  CardModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
  });

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'] ?? 0,
      categoryId: map['category_id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
    };
  }
}

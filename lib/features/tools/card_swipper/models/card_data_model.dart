import 'package:tayssir/features/tools/card_swipper/models/card_model.dart';
import 'package:tayssir/features/tools/card_swipper/models/category_model.dart';
import 'package:tayssir/features/tools/card_swipper/models/topic_model.dart';

class CardDataModel {
  final List<TopicModel> topics;
  final List<CategoryModel> categories;
  final List<CardModel> cards;

  CardDataModel({
    required this.topics,
    required this.categories,
    required this.cards,
  });

  // empty factory
  factory CardDataModel.empty() {
    return CardDataModel(
      topics: [],
      categories: [],
      cards: [],
    );
  }

  factory CardDataModel.fromMap(Map<String, dynamic> map) {
    final topicsData = map['topics'] as List? ?? [];
    final categoriesData = map['categories'] as List? ?? [];
    final cardsData = map['cards'] as List? ?? [];

    return CardDataModel(
      topics: topicsData
          .map<TopicModel>((topic) => TopicModel.fromMap(topic))
          .toList(),
      categories: categoriesData
          .map<CategoryModel>((category) => CategoryModel.fromMap(category))
          .toList(),
      cards: cardsData
          .map<CardModel>((card) => CardModel.fromMap(card))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topics': topics.map((topic) => topic.toMap()).toList(),
      'categories': categories.map((category) => category.toMap()).toList(),
      'cards': cards.map((card) => card.toMap()).toList(),
    };
  }
}

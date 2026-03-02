import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/tools/card_swipper/models/card_model.dart';
import 'package:tayssir/features/tools/card_swipper/models/category_model.dart';
import 'package:tayssir/features/tools/card_swipper/models/topic_model.dart';
import 'package:tayssir/utils/extensions/strings.dart';

class CardSwipperState extends Equatable {
  final List<TopicModel> allTopics;
  final List<CategoryModel> allCategories;
  final List<CardModel> allCards;

  final int? selectedTopicId;
  final int? selectedCategoryId;
  final List<CardModel> currentCards;
  final CardSwiperController cardController;

  const CardSwipperState({
    required this.allTopics,
    required this.allCategories,
    required this.allCards,
    this.selectedTopicId,
    this.selectedCategoryId,
    required this.currentCards,
    required this.cardController,
  });

  CardSwipperState copyWith({
    List<TopicModel>? filteredTopics,
    int? selectedTopicId,
    int? selectedCategoryId,
    List<CardModel>? currentCards,
    CardSwiperController? cardController,
    bool setSelectedTopicIdNull = false,
    bool setSelectedCategoryIdNull = false,
    List<CategoryModel>? allCategories,
    List<CardModel>? allCards,
  }) {
    return CardSwipperState(
      allTopics: filteredTopics ?? allTopics,
      selectedTopicId: setSelectedTopicIdNull
          ? null
          : (selectedTopicId ?? this.selectedTopicId),
      selectedCategoryId: setSelectedCategoryIdNull
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      currentCards: currentCards ?? this.currentCards,
      cardController: cardController ?? this.cardController,
      allCategories: allCategories ?? this.allCategories,
      allCards: allCards ?? this.allCards,
    );
  }

  // set data
  CardSwipperState setData({
    required List<TopicModel> allTopics,
    required List<CategoryModel> allCategories,
    required List<CardModel> allCards,
  }) {
    return copyWith(
      filteredTopics: allTopics,
      allCategories: allCategories,
      allCards: allCards,
    );
  }

  // reset filter , by making selectedTopicId and selectedCategoryId null
  CardSwipperState resetFilter() {
    return copyWith(
      selectedTopicId: null,
      selectedCategoryId: null,
      setSelectedTopicIdNull: true,
      setSelectedCategoryIdNull: true,
    );
  }

  // is topic selected
  bool get isTopicSelected => selectedTopicId != null;

  bool isTopicIdSelected(int topicId) {
    return selectedTopicId == topicId;
  }

  List<CategoryModel> get currentCategories {
    if (selectedTopicId == null) return [];
    return allCategories
        .where((category) => category.topicId == selectedTopicId)
        .toList();
  }

  List<Color> getCardColorsPerCat(int categoryId) {
    final category =
        allCategories.firstWhere((category) => category.id == categoryId);
    final topic = allTopics.firstWhere((topic) => topic.id == category.topicId);
    AppLogger.logInfo('category: $category, topic: $topic');
    return [
      Color(topic.color.toHexColor),
      Color(topic.secondaryColor.toHexColor),
    ];
  }

  List<Color> get topicColors {
    if (selectedTopicId == null) {
      return [
        Colors.blue.shade500,
        Colors.indigo.shade700,
      ];
    }
    final topic = allTopics.firstWhere((topic) => topic.id == selectedTopicId!);
    AppLogger.logInfo('topic: $topic');
    return [
      Color(topic.color.toHexColor),
      Color(topic.secondaryColor.toHexColor),
    ];
  }

  @override
  List<Object?> get props => [
        selectedTopicId,
        selectedCategoryId,
        allTopics,
        currentCards,
        cardController,
        allCategories,
        allCards,
      ];
}

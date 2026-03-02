import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/tools/card_swipper/models/card_data_model.dart';
import 'package:tayssir/features/tools/card_swipper/models/card_model.dart';
import 'package:tayssir/features/tools/card_swipper/state/card_swipper_state.dart';
import 'package:tayssir/features/tools/common/data/tool_repository.dart';
import 'package:tayssir/providers/user/user_notifier.dart';

final cardDataProvider = FutureProvider<CardDataModel>((ref) async {
  // final jsonString = await rootBundle.loadString('assets/data/config.json');
  // final Map<String, dynamic> jsonMap = json.decode(jsonString);
  // // return jsonMap;
  // return CardDataModel.fromMap(jsonMap);
  final toolRepository = ref.watch(toolRepositoryProvider);
  final data = await toolRepository.getCardsData();
  return data;
});

final cardSwipperControllerProvider =
    StateNotifierProvider<CardSwipperNotifier, CardSwipperState>((ref) {
  return CardSwipperNotifier(
      ref,
      ref.watch(cardDataProvider).isLoading
          ? CardDataModel.empty()
          : ref.watch(cardDataProvider).requireValue);
});

class CardSwipperNotifier extends StateNotifier<CardSwipperState> {
  final Ref ref;
  final CardDataModel configData;
  CardSwipperNotifier(this.ref, this.configData)
      : super(CardSwipperState(
          allTopics: const [],
          currentCards: const [],
          allCategories: const [],
          allCards: const [],
          cardController: CardSwiperController(),
        )) {
    _initialize();
  }
  // void getData() {
  //   // This method is not used in the current implementation.
  //   // It can be used to fetch data from an API or database if needed.
  // }
  // Future<Map<String, dynamic>> loadConfig() async {
  //   final jsonString = await rootBundle.loadString('assets/data/config.json');
  //   final Map<String, dynamic> jsonMap = json.decode(jsonString);
  //   return jsonMap;
  // }

  Future<void> _initialize() async {
    final data = configData;
    final isSubscriber = ref.watch(userNotifierProvider).valueOrNull?.isSub ?? false;
    // final topicsData = data.to as List;
    // final topics = topicsData
    //     .map<DummyTopicModel>((topic) => DummyTopicModel.fromMap(topic))
    //     .toList();
    // final categoriesData = data['categories'] as List;
    // final categories = categoriesData
    //     .map<DummyCategoryModel>(
    //         (category) => DummyCategoryModel.fromMap(category))
    //     .toList();
    // final cardsData = data['cards'] as List;
    // final cards = cardsData
    //     .map<DummyCardModel>((card) => DummyCardModel.fromMap(card))
    //     .toList();
    List<CardModel> cards = data.cards
        .map<CardModel>((card) => CardModel.fromMap(card.toMap()))
        .toList();

    if (!isSubscriber) {
      // cards.removeRange(AppConsts.freeCards, cards.length);
      // cards.take(AppConsts.freeCards).toList();
      cards.shuffle();
      cards = cards.take(AppConsts.freeCards).toList();
    }
    state = state.setData(
      allTopics: data.topics,
      allCategories: data.categories,
      allCards: cards,
    );
    state = state.copyWith(
      currentCards: cards,
    );
  }

  void selectTopic(int? topicId) {
    if (topicId == state.selectedTopicId) return;
    state = state.copyWith(
      selectedTopicId: topicId,
      selectedCategoryId: null,
      setSelectedCategoryIdNull: true,
    );

    _updateFilteredCards();
  }

  // a function to reverse the shuffling
  void reverseShuffleCards() {
    final reversedCards = [...state.currentCards]
      ..sort((a, b) => a.id.compareTo(b.id));
    state = state.copyWith(currentCards: reversedCards);
    state.cardController.moveTo(0);
  }

  void selectCategory(int? categoryId) {
    if (categoryId == state.selectedCategoryId) return;
    if (categoryId == null) {
      state = state.copyWith(
        selectedCategoryId: null,
        setSelectedCategoryIdNull: true,
      );
    } else {
      state = state.copyWith(
        selectedCategoryId: categoryId,
      );
    }

    _updateFilteredCards();
  }

  void _updateFilteredCards() {
    final topicId = state.selectedTopicId;
    final categoryId = state.selectedCategoryId;

    List<CardModel> cards = [];
    resetCardSwiperController();

    if (topicId != null) {
      // Get categories for this topic
      final topicCategories = state.allCategories
          .where((category) => category.topicId == topicId)
          .map((category) => category.id)
          .toList();

      if (categoryId != null) {
        // Filter by specific category
        cards = state.allCards
            .where((card) => card.categoryId == categoryId)
            .toList();
      } else {
        // All cards from this topic's categories
        cards = state.allCards
            .where((card) => topicCategories.contains(card.categoryId))
            .toList();
      }
    } else if (categoryId != null) {
      // Just filter by category regardless of topic
      cards = state.allCards
          .where((card) => card.categoryId == categoryId)
          .toList();
    } else {
      AppLogger.logInfo('No filters applied, showing all cards.');

      cards = List.from(
        state.allCards,
      );
    }
    // AppLogger.logInfo(
    //   'Filtered cards: ${cards.length}',
    // );
    state = state.copyWith(currentCards: cards);
  }

  void shuffleCards() {
    final shuffledCards = [...state.currentCards]..shuffle();
    state = state.copyWith(currentCards: shuffledCards);
  }

  void resetFilters() {
    state = state.resetFilter();

    _updateFilteredCards();
  }

  void resetCardSwiperController() {
    state.cardController.moveTo(0);
  }

  void swipeLeft() {
    state.cardController.swipe(
      CardSwiperDirection.left,
    );
  }

  void swipeRight() {
    state.cardController.swipe(
      CardSwiperDirection.right,
    );
  }
}

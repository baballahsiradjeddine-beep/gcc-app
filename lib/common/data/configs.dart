// final configsProvider  = FutureProvider<ConfigsModel>

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/constants/end_points.dart';
import 'package:tayssir/providers/dio/dio.dart';

class ConfigModel {
  final bool cardsActive;
  final bool bacSolutionsActive;
  final bool resumesActive;
  final String appVersion;
  final String paymentName;
  final String paymentNumber;
  final bool isChargilyActive;
  final String tourMaterialGridImage;
  final String tourMaterialListImage;
  final String tourUnitImage;
  final String tourChapterImage;
  final bool titoActive;
  final String titoPersona;
  final String titoWelcomeMessage;
  final String titoApiKey;
  final List<String> titoQaList;
  final String titoAppGoal;
  final String titoSubscriptionPrice;
  final String titoAvailableMaterials;
  final String titoSocialLinks;
  final bool titoStrictMode;

  ConfigModel({
    required this.cardsActive,
    required this.bacSolutionsActive,
    required this.resumesActive,
    required this.appVersion,
    required this.paymentName,
    required this.paymentNumber,
    required this.isChargilyActive,
    required this.tourMaterialGridImage,
    required this.tourMaterialListImage,
    required this.tourUnitImage,
    required this.tourChapterImage,
    required this.titoActive,
    required this.titoPersona,
    required this.titoWelcomeMessage,
    required this.titoApiKey,
    required this.titoQaList,
    required this.titoAppGoal,
    required this.titoSubscriptionPrice,
    required this.titoAvailableMaterials,
    required this.titoSocialLinks,
    required this.titoStrictMode,
  });
  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      cardsActive: map['cards_tools_active'] ?? false,
      bacSolutionsActive: map['bac_solutions_active'] ?? false,
      resumesActive: map['resumes_active'] ?? false,
      appVersion: map['app_version'] ?? '',
      paymentName: map['payment_name'] ?? '',
      paymentNumber: map['payment_number'] ?? '',
      isChargilyActive: map['chargily_payment_active'] ?? true,
      tourMaterialGridImage: map['tour_material_grid_image'] ?? '',
      tourMaterialListImage: map['tour_material_list_image'] ?? '',
      tourUnitImage: map['tour_unit_image'] ?? '',
      tourChapterImage: map['tour_chapter_image'] ?? '',
      titoActive: map['tito_active'] ?? true,
      titoPersona: map['tito_persona'] ?? '',
      titoWelcomeMessage: map['tito_welcome_message'] ?? '',
      titoApiKey: map['tito_api_key'] ?? '',
      titoQaList: List<String>.from(map['tito_qa_list'] ?? []),
      titoAppGoal: map['tito_app_goal'] ?? '',
      titoSubscriptionPrice: map['tito_subscription_price'] ?? '',
      titoAvailableMaterials: map['tito_available_materials'] ?? '',
      titoSocialLinks: map['tito_social_links'] ?? '',
      titoStrictMode: map['tito_strict_mode'] ?? true,
    );
  }
}

final configsProvider = FutureProvider<ConfigModel>((ref) async {
  final dio = ref.watch(dioProvider);
  try {
    final response = await dio.get(EndPoints.settings);
    final data = response.data['data'];
    return ConfigModel.fromMap(data);
  } catch (e) {
    return ConfigModel(
      cardsActive: false,
      bacSolutionsActive: false,
      resumesActive: false,
      appVersion: '1.2.6',
      paymentName: 'BAYAN E-LEARNING',
      paymentNumber: '0022500000000',
      isChargilyActive: true,
      tourMaterialGridImage: '',
      tourMaterialListImage: '',
      tourUnitImage: '',
      tourChapterImage: '',
      titoActive: true,
      titoWelcomeMessage: 'أهلاً بك يا بطل! أنا تيتو، كيفاش نقدر نعاونك اليوم بخصوص قرايتك أو اشتراكك؟ 🐬✨',
      titoPersona: '''
أنت "تيتو" (Tito)، المساعد الذكي لتطبيق "تيسير" (Tayssir) التعليمي لطلبة البكالوريا في الجزائر.
مهمتك هي الإجابة على أسئلة الطلاب بذكاء وبطريقة مشجعة ومحفزة.
''',
      titoApiKey: '',
      titoQaList: ["كم سعر الاشتراك؟", "ما هي المواد المتاحة؟", "ما هو هدف التطبيق؟", "كيف أتواصل معكم؟"],
      titoAppGoal: 'تطبيق تيسير يهدف لتبسيط دروس البكالوريا لجميع الشعب في الجزائر عبر فيديوهات وتمارين تفاعلية.',
      titoSubscriptionPrice: 'اشتراك الفصل الواحد بـ 1000 دج، أو العام كاملاً بـ 2500 دج.',
      titoAvailableMaterials: 'كل مواد البكالوريا حسب الشعبة: رياضيات، علوم، فيزياء، لغات، أدب...',
      titoSocialLinks: 'فيسبوك وتيك توك تحت اسم: Tayssir Bac',
      titoStrictMode: true,
    );
  }
});

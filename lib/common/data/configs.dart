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

  ConfigModel({
    required this.cardsActive,
    required this.bacSolutionsActive,
    required this.resumesActive,
    required this.appVersion,
    required this.paymentName,
    required this.paymentNumber,
    required this.isChargilyActive,
  });
  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      cardsActive: map['cards_tools_active'] as bool,
      bacSolutionsActive: map['bac_solutions_active'] as bool,
      resumesActive: map['resumes_active'] as bool,
      appVersion: map['app_version'],
      paymentName: map['payment_name'],
      paymentNumber: map['payment_number'],
      isChargilyActive: map['chargily_payment_active'] as bool,
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
    );
  }
});

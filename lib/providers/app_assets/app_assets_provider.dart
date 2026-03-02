import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/dio/dio.dart';
import 'package:tayssir/constants/end_points.dart';

class AppAssetModel {
  final String url;
  final String version;
  final String label;

  AppAssetModel({
    required this.url,
    required this.version,
    required this.label,
  });

  factory AppAssetModel.fromJson(Map<String, dynamic> json) {
    return AppAssetModel(
      url: json['url'] ?? '',
      version: json['version'] ?? '',
      label: json['label'] ?? '',
    );
  }
}

final appAssetsProvider = FutureProvider<Map<String, AppAssetModel>>((ref) async {
  final request = ref.watch(dioClientProvider);
  try {
    final response = await request.get(EndPoints.appAssets);
    final data = response.data['data'] as Map<String, dynamic>;
    return data.map((key, value) => MapEntry(key, AppAssetModel.fromJson(value)));
  } catch (e) {
    print('Error fetching app assets: $e');
    // If request fails (e.g. no internet), return empty map so UI uses local assets gracefully
    return {};
  }
});

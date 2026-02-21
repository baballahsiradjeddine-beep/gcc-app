import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/settings/contact_us/contact_us_controller.dart';
import 'package:tayssir/features/settings/data/remote_settings_data_source.dart';
import 'package:tayssir/features/settings/domaine/contact_us_model.dart';
import 'package:tayssir/providers/dio/dio.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final remoteSettingsDataSource = ref.watch(remoteSettingsDataSourceProvider);
  return SettingsRepository(remoteSettingsDataSource);
});

final remoteSettingsDataSourceProvider =
    Provider<RemoteSettingsDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return RemoteSettingsDataSource(dioClient);
});

class SettingsRepository {
  final RemoteSettingsDataSource remoteSettingsDataSource;
  SettingsRepository(this.remoteSettingsDataSource);

  Future<void> sendContactUs(ContactUsModel contactUsModel) async {
    try {
      await remoteSettingsDataSource.sendContactUs(contactUsModel);
    } catch (error, stackTrace) {
      throw AppException.fromDartException(error, stackTrace);
    }
  }
}

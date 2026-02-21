import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/settings/data/settings_repository.dart';
import 'package:tayssir/features/settings/domaine/contact_us_model.dart';

final contactUsControllerProvider =
    StateNotifierProvider<ContactUsController, AsyncValue<void>>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return ContactUsController(settingsRepository);
});

class ContactUsController extends StateNotifier<AsyncValue<void>> {
  final SettingsRepository settingsRepository;
  ContactUsController(this.settingsRepository)
      : super(const AsyncValue.data(null));

  Future<void> sendContactUs(ContactUsModel contactUsModel) async {
    state = const AsyncValue.loading();
    try {
      await settingsRepository.sendContactUs(contactUsModel);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e as AppException, st);
    }
  }
}

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayssir/providers/settings/settings_model.dart';

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final localSettingsDataSourceProvider =
    Provider<LocalSettingsDataSource?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).valueOrNull;
  if (prefs == null) return null;
  return LocalSettingsDataSource(sharedPreferences: prefs);
});

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, SettingsModel>((ref) {
  final localSettingsDataSource = ref.watch(localSettingsDataSourceProvider);
  return SettingsNotifier(localSettingsDataSource: localSettingsDataSource);
});

class SettingsNotifier extends StateNotifier<SettingsModel> {
  final LocalSettingsDataSource? localSettingsDataSource;

  SettingsNotifier({required this.localSettingsDataSource})
      : super(SettingsModel.empty()) {
    if (localSettingsDataSource != null) getSettings();
  }

  Future<void> getSettings() async {
    if (localSettingsDataSource == null) return;
    final settings = await localSettingsDataSource!.getSettings();
    state = settings;
  }

  // toggle sound
  Future<void> toggleSound() async {
    final newSettings = state.copyWith(isSoundEnabled: !state.isSoundEnabled);
    state = newSettings;
    await localSettingsDataSource?.saveSettings(newSettings);
  }

  // toggle vibration
  Future<void> toggleVibration() async {
    final newSettings = state.copyWith(isVibrationEnabled: !state.isVibrationEnabled);
    state = newSettings;
    await localSettingsDataSource?.saveSettings(newSettings);
  }

  // toggle dark mode
  Future<void> toggleDarkMode() async {
    final newSettings = state.copyWith(isDarkMode: !state.isDarkMode);
    state = newSettings;
    await localSettingsDataSource?.saveSettings(newSettings);
  }
}

class LocalSettingsDataSource {
  final SharedPreferences sharedPreferences;

  LocalSettingsDataSource({required this.sharedPreferences});

  static const String _key = 'settings';

  Future<SettingsModel> getSettings() async {
    final settingsJson = sharedPreferences.getString(_key);
    if (settingsJson == null) {
      return SettingsModel.empty();
    }
    return SettingsModel.fromMap(jsonDecode(settingsJson));
  }

  // save settings
  Future<void> saveSettings(SettingsModel settings) async {
    final settingsJson = jsonEncode(settings.toMap());
    await sharedPreferences.setString(_key, settingsJson);
  }
}

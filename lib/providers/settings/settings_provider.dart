import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayssir/providers/settings/settings_model.dart';

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final localSettingsDataSourceProvider =
    Provider<LocalSettingsDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider).requireValue;
  return LocalSettingsDataSource(sharedPreferences: sharedPreferences);
});

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, SettingsModel>((ref) {
  final localSettingsDataSource = ref.watch(localSettingsDataSourceProvider);
  return SettingsNotifier(localSettingsDataSource: localSettingsDataSource);
});

class SettingsNotifier extends StateNotifier<SettingsModel> {
  final LocalSettingsDataSource localSettingsDataSource;

  SettingsNotifier({required this.localSettingsDataSource})
      : super(SettingsModel.empty()) {
    // getSettings();
  }

  Future<void> getSettings() async {
    final settings = await localSettingsDataSource.getSettings();
    state = settings;
  }

// toggle sound
  Future<void> toggleSound() async {
    final newSettings = state.copyWith(isSoundEnabled: !state.isSoundEnabled);
    state = newSettings;
    await localSettingsDataSource.saveSettings(newSettings);
  }

  // Future<void> saveSettings(Settings settings) async {
  //   await localSettingsDataSource.saveSettings(settings);
  //   state = settings;
  // }
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

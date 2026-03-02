import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  // is sound enabled
  final bool isSoundEnabled;

  // is vibration enabled
  final bool isVibrationEnabled;

  final bool isDarkMode;

  const SettingsModel({
    required this.isSoundEnabled,
    required this.isVibrationEnabled,
    required this.isDarkMode,
  });

  factory SettingsModel.empty() {
    return const SettingsModel(
      isSoundEnabled: true,
      isVibrationEnabled: true,
      isDarkMode: true,
    );
  }

  // from map
  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      isSoundEnabled: map['isSoundEnabled'] ?? true,
      isVibrationEnabled: map['isVibrationEnabled'] ?? true,
      isDarkMode: map['isDarkMode'] ?? true,
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      'isSoundEnabled': isSoundEnabled,
      'isVibrationEnabled': isVibrationEnabled,
      'isDarkMode': isDarkMode,
    };
  }

  @override
  List<Object> get props => [isSoundEnabled, isVibrationEnabled, isDarkMode];

  @override
  bool get stringify => true;

  SettingsModel copyWith({
    bool? isSoundEnabled,
    bool? isVibrationEnabled,
    bool? isDarkMode,
  }) {
    return SettingsModel(
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

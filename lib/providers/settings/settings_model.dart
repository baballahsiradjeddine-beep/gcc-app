import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  // is sound enabled
  final bool isSoundEnabled;

  // is vibration enabled
  final bool isVibrationEnabled;

  const SettingsModel({
    required this.isSoundEnabled,
    required this.isVibrationEnabled,
  });

  factory SettingsModel.empty() {
    return const SettingsModel(
      isSoundEnabled: true,
      isVibrationEnabled: true,
    );
  }

  // from map
  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      isSoundEnabled: map['isSoundEnabled'],
      isVibrationEnabled: map['isVibrationEnabled'],
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      'isSoundEnabled': isSoundEnabled,
      'isVibrationEnabled': isVibrationEnabled,
    };
  }

  @override
  List<Object> get props => [isSoundEnabled, isVibrationEnabled];

  @override
  bool get stringify => true;

  SettingsModel copyWith({
    bool? isSoundEnabled,
    bool? isVibrationEnabled,
  }) {
    return SettingsModel(
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
    );
  }
}

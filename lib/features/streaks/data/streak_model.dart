import 'package:equatable/equatable.dart';

class StreakDay extends Equatable {
  final String date;
  final String dayName;
  final bool studied;
  final bool isToday;

  const StreakDay({
    required this.date,
    required this.dayName,
    required this.studied,
    required this.isToday,
  });

  factory StreakDay.fromJson(Map<String, dynamic> json) {
    return StreakDay(
      date: json['date'] as String,
      dayName: json['day_name'] as String,
      studied: json['studied'] as bool,
      isToday: json['is_today'] as bool,
    );
  }

  @override
  List<Object?> get props => [date, dayName, studied, isToday];
}

class StreakModel extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final List<StreakDay> history;
  final bool streakIncreasedToday;

  const StreakModel({
    required this.currentStreak,
    required this.longestStreak,
    required this.history,
    this.streakIncreasedToday = false,
  });

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      currentStreak: json['current_streak'] as int,
      longestStreak: json['longest_streak'] as int,
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => StreakDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      streakIncreasedToday: json['streak_increased_today'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props =>
      [currentStreak, longestStreak, history, streakIncreasedToday];
}

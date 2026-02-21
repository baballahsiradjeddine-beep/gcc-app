class ProgressModel {
  final int id;
  final double progress;
  final int points;
  final int? bonusPoints;
  ProgressModel({
    required this.id,
    required this.progress,
    required this.points,
    this.bonusPoints,
  });

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
        id: map['id'],
        progress: map['progress'] == null
            ? 20.0
            : map['progress'] is int
                ? (map['progress'] as int).toDouble()
                : map['progress'] as double,
        points: map['earned_points'] == null ? 0 : map['earned_points'] as int,
        bonusPoints: map['earned_bonus_points'] == null
            ? null
            : map['earned_bonus_points'] as int);
  }
}

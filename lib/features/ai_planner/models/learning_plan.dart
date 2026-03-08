import 'package:equatable/equatable.dart';

class PlanItem extends Equatable {
  final String id;
  final String title;
  final String timeRange; // e.g., "00:00 - 00:10"
  final String description;
  final bool isCompleted;
  final String? subjectId;
  final String? unitId;
  final int? chapterId; // ID for direct navigation
  final String type; // 'study', 'exercise', 'review'

  const PlanItem({
    required this.id,
    required this.title,
    required this.timeRange,
    required this.description,
    this.isCompleted = false,
    this.subjectId,
    this.unitId,
    this.chapterId,
    this.type = 'study',
  });

  PlanItem copyWith({
    String? id,
    String? title,
    String? timeRange,
    String? description,
    bool? isCompleted,
    String? subjectId,
    String? unitId,
    int? chapterId,
    String? type,
  }) {
    return PlanItem(
      id: id ?? this.id,
      title: title ?? this.title,
      timeRange: timeRange ?? this.timeRange,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      subjectId: subjectId ?? this.subjectId,
      unitId: unitId ?? this.unitId,
      chapterId: chapterId ?? this.chapterId,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [id, title, timeRange, description, isCompleted, subjectId, unitId, chapterId, type];
}

class LearningPlan extends Equatable {
  final String id;
  final List<String> subjects;
  final int totalDurationMinutes;
  final List<PlanItem> items;
  final DateTime createdAt;
  final bool isFinished;

  const LearningPlan({
    required this.id,
    required this.subjects,
    required this.totalDurationMinutes,
    required this.items,
    required this.createdAt,
    this.isFinished = false,
  });

  LearningPlan copyWith({
    String? id,
    List<String>? subjects,
    int? totalDurationMinutes,
    List<PlanItem>? items,
    DateTime? createdAt,
    bool? isFinished,
  }) {
    return LearningPlan(
      id: id ?? this.id,
      subjects: subjects ?? this.subjects,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  @override
  List<Object?> get props => [id, subjects, totalDurationMinutes, items, createdAt, isFinished];
}

import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/learning_plan.dart';

class AIPlannerState {
  final LearningPlan? activePlan;
  final bool isLoading;

  AIPlannerState({this.activePlan, this.isLoading = false});

  AIPlannerState copyWith({LearningPlan? activePlan, bool? isLoading}) {
    return AIPlannerState(
      activePlan: activePlan ?? this.activePlan,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final aiPlannerProvider = StateNotifierProvider<AIPlannerNotifier, AIPlannerState>((ref) {
  return AIPlannerNotifier();
});

class AIPlannerNotifier extends StateNotifier<AIPlannerState> {
  AIPlannerNotifier() : super(AIPlannerState());

  Future<void> generatePlan({
    required List<String> subjects,
    required List<String> subjectNames,
    required int durationMinutes,
  }) async {
    state = state.copyWith(isLoading: true);
    
    // Simulate AI Generation
    await Future.delayed(const Duration(seconds: 2));

    final List<PlanItem> items = [];
    int currentMinutes = 0;
    
    // Simple algorithm to divide time
    final int baseTimePerSubject = durationMinutes ~/ subjects.length;
    
    for (int i = 0; i < subjects.length; i++) {
      final String subjectName = subjectNames[i];
      
      // Warmup/Review (15%)
      final warmupEnd = currentMinutes + (baseTimePerSubject * 0.2).toInt();
      items.add(PlanItem(
        id: 'warmup_$i',
        title: 'مراجعة سريعة: $subjectName 📓',
        timeRange: '${_format(currentMinutes)} - ${_format(warmupEnd)}',
        description: 'راجع القواعد الأساسية والملاحظات السابقة للمادة.',
        type: 'review',
        subjectId: subjects[i],
      ));
      currentMinutes = warmupEnd;

      // Core Study (60%)
      final studyEnd = currentMinutes + (baseTimePerSubject * 0.6).toInt();
      items.add(PlanItem(
        id: 'study_$i',
        title: 'دراسة الدرس الأساسي: $subjectName 🧠',
        timeRange: '${_format(currentMinutes)} - ${_format(studyEnd)}',
        description: 'ركز على فهم المفاهيم الجديدة وحفظ القوانين المهمة.',
        type: 'study',
        subjectId: subjects[i],
      ));
      currentMinutes = studyEnd;

      // Practice (25%)
      final practiceEnd = currentMinutes + (baseTimePerSubject * 0.2).toInt();
      items.add(PlanItem(
        id: 'exercise_$i',
        title: 'حل تطبيقات وعمليات: $subjectName ✏️',
        timeRange: '${_format(currentMinutes)} - ${_format(practiceEnd)}',
        description: 'قم بحل مجموعة من التمارين داخل تطبيق "بيان" لتثبيت المعلومة.',
        type: 'exercise',
        subjectId: subjects[i],
      ));
      currentMinutes = practiceEnd;
    }

    final newPlan = LearningPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subjects: subjects,
      totalDurationMinutes: durationMinutes,
      items: items,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(activePlan: newPlan, isLoading: false);
  }

  String _format(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  void toggleItem(String itemId) {
    if (state.activePlan == null) return;
    
    final newItems = state.activePlan!.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return item;
    }).toList();

    final bool allDone = newItems.every((it) => it.isCompleted);

    state = state.copyWith(
      activePlan: state.activePlan!.copyWith(
        items: newItems,
        isFinished: allDone,
      ),
    );
  }

  void markSubjectTaskDone(String subjectId, String type) {
     if (state.activePlan == null) return;
     
     final newItems = state.activePlan!.items.map((item) {
      if (item.subjectId == subjectId && item.type == type && !item.isCompleted) {
        return item.copyWith(isCompleted: true);
      }
      return item;
    }).toList();

    final bool allDone = newItems.every((it) => it.isCompleted);

    state = state.copyWith(
      activePlan: state.activePlan!.copyWith(
        items: newItems,
        isFinished: allDone,
      ),
    );
  }

  void resetPlan() {
    state = state.copyWith(activePlan: null);
  }
}

import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/data/data_provider.dart';
import '../models/learning_plan.dart';

class AIPlannerState {
  final LearningPlan? activePlan;
  final bool isLoading;

  AIPlannerState({this.activePlan, this.isLoading = false});

  AIPlannerState copyWith({
    LearningPlan? activePlan, 
    bool? isLoading,
    bool clearPlan = false,
  }) {
    return AIPlannerState(
      activePlan: clearPlan ? null : (activePlan ?? this.activePlan),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final aiPlannerProvider = StateNotifierProvider<AIPlannerNotifier, AIPlannerState>((ref) {
  return AIPlannerNotifier(ref);
});

final isFromAiPlannerProvider = StateProvider<bool>((ref) => false);
final isPlannerSessionActiveProvider = StateProvider<bool>((ref) => false);

class AIPlannerNotifier extends StateNotifier<AIPlannerState> {
  final Ref ref;
  AIPlannerNotifier(this.ref) : super(AIPlannerState());

  Future<void> generatePlan({
    required List<String> subjects,
    required List<String> subjectNames,
    required int durationMinutes,
  }) async {
    state = state.copyWith(isLoading: true, clearPlan: true);
    
    // Simulate AI reasoning
    await Future.delayed(const Duration(seconds: 2));

    final dataState = ref.read(dataProvider);
    final List<PlanItem> selectedItems = [];

    // Updated Smart Logic: Task density as requested
    int maxTasks = 3; // Default for 10 min
    if (durationMinutes == 20) maxTasks = 6;
    if (durationMinutes >= 30) maxTasks = 10;

    final List<_CandidateChapter> allCandidates = [];

    for (int i = 0; i < subjects.length; i++) {
      final materialId = int.parse(subjects[i]);
      final materialName = subjectNames[i];
      
      final relevantUnits = dataState.contentData.units.where((u) => u.materialId == materialId).toList();
      
      for (final unit in relevantUnits) {
        final chapters = dataState.contentData.chapters.where((c) => c.unitId == unit.id).toList();
        for (final chapter in chapters) {
          if (chapter.progress < 100) {
            allCandidates.add(_CandidateChapter(
              chapter: chapter,
              unit: unit,
              subjectName: materialName,
            ));
          }
        }
      }
    }

    // Prioritize Improvement (0 < p < 100) over New (p == 0)
    final needsImprovement = allCandidates.where((c) => c.chapter.progress > 0).toList();
    final notStarted = allCandidates.where((c) => c.chapter.progress == 0).toList();

    needsImprovement.sort((a, b) => a.chapter.progress.compareTo(b.chapter.progress)); // Weakest first
    notStarted.sort((a, b) => a.chapter.id.compareTo(b.chapter.id)); // Order of program

    final finalQueue = [...needsImprovement, ...notStarted];

    for (int i = 0; i < min(maxTasks, finalQueue.length); i++) {
      final cand = finalQueue[i];
      selectedItems.add(PlanItem(
        id: 'task_${cand.chapter.id}_${DateTime.now().millisecondsSinceEpoch}_$i',
        title: cand.chapter.title,
        timeRange: cand.unit.title,
        description: cand.chapter.progress > 0 
            ? 'أولوية إتقان: مستواك الحالي ${cand.chapter.progress.toInt()}%، فلنكمل الفصل.'
            : 'فصل جديد: ابدأ دراسة هذا الموضوع في مادة ${cand.subjectName}.',
        type: 'study',
        subjectId: cand.unit.materialId.toString(),
        unitId: cand.unit.id.toString(),
        chapterId: cand.chapter.id,
      ));
    }

    if (selectedItems.isEmpty && subjects.isNotEmpty) {
      selectedItems.add(PlanItem(
        id: 'review_fallback',
        title: 'مراجعة شاملة للمواد المختارة',
        timeRange: 'تحضير عام',
        description: 'يبدو أنك أنجزت كل شيء! قم بمراجعة ملخصاتك سرياً.',
        type: 'study',
        subjectId: subjects.first,
      ));
    }
    // Group by Subject to make Dividers work correctly
    selectedItems.sort((a, b) => (a.subjectId ?? '').compareTo(b.subjectId ?? ''));

    final newPlan = LearningPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subjects: subjects,
      totalDurationMinutes: durationMinutes,
      items: selectedItems,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(activePlan: newPlan, isLoading: false, clearPlan: false);
  }

  void markChapterTaskDone(int chapterId, String type) {
    if (state.activePlan == null) return;
    
    final newItems = state.activePlan!.items.map((item) {
      // Mark BOTH 'study' and 'exercise' for this chapter as done
      // since the user completed the chapter's requirement
      if (item.chapterId == chapterId && !item.isCompleted) {
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
    state = state.copyWith(clearPlan: true);
  }
}

class _CandidateChapter {
  final dynamic chapter;
  final dynamic unit;
  final String subjectName;

  _CandidateChapter({required this.chapter, required this.unit, required this.subjectName});
}

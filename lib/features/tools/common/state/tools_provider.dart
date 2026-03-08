import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/data/configs.dart';
import 'package:tayssir/features/home/presentation/widgets/course_widget.dart';
import 'package:tayssir/features/tools/common/models/tool_model.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/router/app_router.dart';

final toolsProvider = Provider<List<ToolModel>>((ref) {
  final configs = ref.watch(configsProvider).requireValue;
  final allTools = [
    ToolModel(
      name: 'بطاقات بيان',
      description: 'بطاقات تعليمية تفاعلية',
      pathName: AppRoutes.cardSwipper.name,
      startColor: const Color(0xffCB2487),
      endColor: const Color(0xffFD67C0),
      isLocked: !configs.cardsActive,
      toolImage: ToolImage(
        grid: configs.toolCardsGrid.isNotEmpty ? configs.toolCardsGrid : Images.flashCardsGBg,
        list: configs.toolCardsList.isNotEmpty ? configs.toolCardsList : Images.flashCardsLBg,
      ),
    ),
    ToolModel(
      name: 'المؤقت البومودورو',
      description: 'تقنية لإدارة الوقت إلى فترات مدتها 25 د .',
      pathName: AppRoutes.pomodoro.name,
      startColor: const Color(0xFF0F726D),
      endColor: const Color(0xFF48CFCB),
      isLocked: false,
      toolImage: ToolImage(
        grid: configs.toolPomodoroGrid.isNotEmpty ? configs.toolPomodoroGrid : Images.pomodoroBg,
        list: configs.toolPomodoroList.isNotEmpty ? configs.toolPomodoroList : Images.pomodoroBgList,
      ),
      isStartBottomColor: false,
    ),
    ToolModel(
      name: 'حاسبة الدرجات',
      description: 'قم بحساب درجاتك بسهولة',
      pathName: AppRoutes.gradeCalculator.name,
      startColor: const Color(0xFF00B2FF),
      endColor: const Color(0xFF054A91),
      isLocked: false,
      toolImage: ToolImage(
          grid: configs.toolGradeCalcGrid.isNotEmpty ? configs.toolGradeCalcGrid : Images.gradeCalcGrid, 
          list: configs.toolGradeCalcList.isNotEmpty ? configs.toolGradeCalcList : Images.gradeCalcList),
    ),
    ToolModel(
      name: 'ملخصات و مراجعات',
      description: 'ملخصات و مراجعات للدروس',
      pathName: AppRoutes.resumes.name,
      startColor: const Color(0xff533899),
      endColor: const Color(0xFF563A9C),
      isLocked: !configs.resumesActive,
      toolImage: ToolImage(
        grid: configs.toolResumesGrid.isNotEmpty ? configs.toolResumesGrid : Images.resumesGBg,
        list: configs.toolResumesList.isNotEmpty ? configs.toolResumesList : Images.resumsLBg,
      ),
    ),
    ToolModel(
      name: 'حلول البكالوريا',
      description: 'الحلل النموجي للباكالوريات السابقة',
      pathName: AppRoutes.bacs.name,
      startColor: const Color(0xFF4C4C4C),
      endColor: const Color(0xFFA9A9A9),
      isLocked: !configs.bacSolutionsActive,
      toolImage: ToolImage(
        grid: configs.toolBacSolutionsGrid.isNotEmpty ? configs.toolBacSolutionsGrid : Images.reolveGridBg,
        list: configs.toolBacSolutionsList.isNotEmpty ? configs.toolBacSolutionsList : Images.resolveListBg,
      ),
      isStartBottomColor: false,
    ),
    ToolModel(
      name: 'خطة الدراسة الذكية',
      description: 'نظام المهام الذكي (Checked List) لتحقيق أهدافك مراجعة يومية.',
      pathName: 'ai_planner',
      startColor: const Color(0xFF00C6E0),
      endColor: const Color(0xFF0077B6),
      isLocked: false,
      toolImage: ToolImage(
        grid: configs.toolAiPlannerGrid.isNotEmpty ? configs.toolAiPlannerGrid : Images.pomodoroBg, 
        list: configs.toolAiPlannerList.isNotEmpty ? configs.toolAiPlannerList : Images.pomodoroBgList,
      ),
      isStartBottomColor: false,
    ),
  ];
  return allTools.where((tool) => !tool.isLocked).toList();
});

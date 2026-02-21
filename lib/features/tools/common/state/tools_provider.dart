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
      name: 'بطاقات تيسير',
      description: 'بطاقات تعليمية تفاعلية',
      pathName: AppRoutes.cardSwipper.name,
      startColor: const Color(0xffCB2487),
      endColor: const Color(0xffFD67C0),
      isLocked: !configs.cardsActive,
      toolImage: const ToolImage(
        grid: Images.flashCardsGBg,
        list: Images.flashCardsLBg,
      ),
    ),
    ToolModel(
      name: 'المؤقت البومودورو',
      description: 'تقنية لإدارة الوقت إلى فترات مدتها 25 د .',
      pathName: AppRoutes.pomodoro.name,
      startColor: const Color(0xFF0F726D),
      endColor: const Color(0xFF48CFCB),
      isLocked: false,
      toolImage: const ToolImage(
        grid: Images.pomodoroBg,
        list: Images.pomodoroBgList,
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
      toolImage: const ToolImage(
          grid: Images.gradeCalcGrid, list: Images.gradeCalcList),
    ),
    ToolModel(
      name: 'ملخصات و مراجعات',
      description: 'ملخصات و مراجعات للدروس',
      pathName: AppRoutes.resumes.name,
      startColor: const Color(0xff533899),
      endColor: const Color(0xFF563A9C),
      isLocked: !configs.resumesActive,
      toolImage: const ToolImage(
        grid: Images.resumesGBg,
        list: Images.resumsLBg,
      ),
    ),
    ToolModel(
      name: 'حلول البكالوريا',
      description: 'الحلل النموجي للباكالوريات السابقة',
      pathName: AppRoutes.bacs.name,
      startColor: const Color(0xFF4C4C4C),
      endColor: const Color(0xFFA9A9A9),
      isLocked: !configs.bacSolutionsActive,
      toolImage: const ToolImage(
        grid: Images.reolveGridBg,
        list: Images.resolveListBg,
      ),
      isStartBottomColor: false,
    ),
  ];
  return allTools.where((tool) => !tool.isLocked).toList();
});

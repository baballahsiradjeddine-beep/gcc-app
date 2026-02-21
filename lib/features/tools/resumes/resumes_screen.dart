import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/tools/card_swipper/card_pattern_painter.dart';
import 'package:tayssir/features/tools/card_swipper/category_filter_section.dart';
import 'package:tayssir/features/tools/common/data/tool_repository.dart';
import 'package:tayssir/features/tools/resumes/models/resume_data_model.dart';
import 'package:tayssir/providers/dio/dio.dart';
import 'package:tayssir/router/app_router.dart';

import 'package:equatable/equatable.dart';

final resumeDataProvider = FutureProvider<ResumeDataModel>((ref) async {
  final res = await ref.watch(toolRepositoryProvider).getResumesData();
  return res;
});

class ResumesScreen extends HookConsumerWidget {
  const ResumesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumeDataAsync = ref.watch(resumeDataProvider);

    return resumeDataAsync.when(
      loading: () => const ResumesLoadingView(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            SizedBox(height: 16.h),
            Text(
              'حدث خطأ في تحميل البيانات',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              error.toString(),
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      data: (data) => ResumesDataView(data: data),
    );
  }
}

class ResumesLoadingView extends StatelessWidget {
  const ResumesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      paddingX: 0,
      paddingY: 0,
      paddingB: 0,
      body: Column(
        children: [
          // Header skeleton
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.indigo.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            padding: EdgeInsets.fromLTRB(8.w, 48.h, 8.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 26.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'ملخصات تيسير',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'جاري تحميل البيانات...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.blue.shade700,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'جاري تحميل الملخصات...',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResumesDataView extends HookWidget {
  final ResumeDataModel data;

  const ResumesDataView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final currentMaterial = useState<int?>(0);
    final scrollController = useScrollController();

    // Filter units if a material is selected
    final displayedUnits =
        currentMaterial.value == 0 || currentMaterial.value == null
            ? data.units
            : data.units
                .where((u) => u.materialId == currentMaterial.value)
                .toList();

    // Get the background gradient colors based on selection
    List<Color> headerGradientColors = currentMaterial.value == 0
        ? [Colors.blue.shade700, Colors.indigo.shade800]
        : data.materials
            .where((item) => item.id == currentMaterial.value)
            .first
            .colors;

    final currentColor = currentMaterial.value == 0
        ? Colors.blue.shade700
        : data.materials
            .where((item) => item.id == currentMaterial.value)
            .first
            .colors[0];

    return AppScaffold(
      paddingX: 0,
      paddingY: 0,
      paddingB: 0,
      body: Column(
        children: [
          // Enhanced Header with gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: headerGradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(8.w, 48.h, 8.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 26.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'ملخصات تيسير',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'مجموعة ${data.units.length} وحدة للمراجعة',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: FilterSection(
                    items: data.materials,
                    isPremium: false,
                    padding: 0,
                    allLabel: 'جميع الملخصات',
                    isAllOptionsPressed: currentMaterial.value == 0,
                    onClearAllSelected: () {
                      currentMaterial.value = 0;
                    },
                    labelColor: currentColor,
                    getLabel: (item) => item.name,
                    selectionExtractor: (item) =>
                        currentMaterial.value == item.id,
                    filterColor: currentMaterial.value == 0
                        ? Colors.white
                        : Colors.white,
                    onItemPressed: (item) {
                      currentMaterial.value = item.id;
                      scrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Stats row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: currentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 18.sp,
                        color: currentColor,
                      ),
                      2.horizontalSpace,
                      Text(
                        '${displayedUnits.length} ${displayedUnits.length == 1 ? 'ملخص' : 'ملخصلات'} للمراجعة',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: currentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: currentMaterial.value == 0
                        ? Colors.blue.shade50
                        : data.materials
                            .where((item) => item.id == currentMaterial.value)
                            .first
                            .colors[0]
                            .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    currentMaterial.value == 0
                        ? 'عرض الكل'
                        : data.materials
                            .where((item) => item.id == currentMaterial.value)
                            .first
                            .name,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: currentMaterial.value == 0
                          ? Colors.blue.shade700
                          : data.materials
                              .where((item) => item.id == currentMaterial.value)
                              .first
                              .colors[0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          // The Grid of Cards
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.w,
                  mainAxisSpacing: 18.h,
                  childAspectRatio: 0.85,
                ),
                itemCount: displayedUnits.length,
                itemBuilder: (context, index) {
                  final unit = displayedUnits[index];
                  final material = data.materials
                      .firstWhere((mat) => mat.id == unit.materialId);

                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(AppRoutes.pdfContent.name, extra: {
                        'pdfUrl': unit.pdf,
                      });
                    },
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: material.colors,
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: CustomPaint(
                                  painter: CardPatternPainter(
                                      color: Colors.white.withOpacity(0.2)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(14.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.22),
                                      borderRadius: BorderRadius.circular(8.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      material.name,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  20.verticalSpace,
                                  Expanded(
                                    child: Text(
                                      unit.name,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.3,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 4.h),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                        ),
                                        child: Text(
                                          'PDF',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

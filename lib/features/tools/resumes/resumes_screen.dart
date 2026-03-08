import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/tools/card_swipper/card_pattern_painter.dart';
import 'package:tayssir/features/tools/card_swipper/category_filter_section.dart';
import 'package:tayssir/features/tools/common/data/tool_repository.dart';
import 'package:tayssir/features/tools/resumes/models/resume_data_model.dart';
import 'package:tayssir/router/app_router.dart';

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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return AppScaffold(
      includeBackButton: true,
      topSafeArea: true,
      paddingX: 20.w,
      bodyBackgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: Text(
        'ملخصات بيان 📚',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
          fontFamily: 'SomarSans',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40.w,
              height: 40.w,
              child: const CircularProgressIndicator(
                color: Color(0xFF00B4D8),
                strokeWidth: 3,
              ),
            ),
            24.verticalSpace,
            Text(
              'جاري تحضير الملخصات...',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black54,
                fontFamily: 'SomarSans',
              ),
            ),
          ],
        ),
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter units if a material is selected
    final displayedUnits =
        currentMaterial.value == 0 || currentMaterial.value == null
            ? data.units
            : data.units
                .where((u) => u.materialId == currentMaterial.value)
                .toList();

    final currentColor = currentMaterial.value == 0
        ? const Color(0xFF00B4D8)
        : data.materials
            .where((item) => item.id == currentMaterial.value)
            .first
            .colors[0];

    return AppScaffold(
      includeBackButton: true,
      topSafeArea: true,
      paddingX: 0,
      paddingY: 0,
      paddingB: 0,
      bodyBackgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: Text(
        'ملخصات بيان 📚',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
          fontFamily: 'SomarSans',
        ),
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
            child: Column(
              children: [
                FilterSection(
                  items: data.materials,
                  isPremium: false,
                  padding: 8,
                  allLabel: 'جميع الملخصات',
                  isAllOptionsPressed: currentMaterial.value == 0,
                  onClearAllSelected: () {
                    currentMaterial.value = 0;
                  },
                  getLabel: (item) => item.name,
                  selectionExtractor: (item) =>
                      currentMaterial.value == item.id,
                  filterColor: const Color(0xFF0077B6),
                  onItemPressed: (item) {
                    currentMaterial.value = item.id;
                    scrollController.animateTo(
                      0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                ),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: currentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: currentColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 14.sp, color: currentColor),
                            6.horizontalSpace,
                            Text(
                              '${displayedUnits.length} وحدة متوفرة',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                                color: currentColor,
                                fontFamily: 'SomarSans',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        currentMaterial.value == 0 ? "كل المواد" : "مادة محددة",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark ? Colors.white54 : Colors.black45,
                          fontFamily: 'SomarSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ],
            ),
          ),

          // The Grid of Cards
          Expanded(
            child: GridView.builder(
              controller: scrollController,
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 40.h),
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
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
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: material.colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: material.colors.first.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: CardPatternPainter(
                                color: Colors.white.withOpacity(0.12)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  material.name,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontFamily: 'SomarSans',
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                unit.name,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontFamily: 'SomarSans',
                                  height: 1.2,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              8.verticalSpace,
                              Row(
                                children: [
                                  Icon(Icons.menu_book_outlined, color: Colors.white.withOpacity(0.8), size: 14.sp),
                                  4.horizontalSpace,
                                  Text(
                                    'قراءة الملخص',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SomarSans',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

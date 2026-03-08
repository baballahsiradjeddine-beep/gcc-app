import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/tools/bacs/models/bacs_data_model.dart';
import 'package:tayssir/features/tools/card_swipper/card_pattern_painter.dart';
import 'package:tayssir/features/tools/card_swipper/category_filter_section.dart';
import 'package:tayssir/router/app_router.dart';

class BacsDataView extends HookWidget {
  final BacsDataModel data;

  const BacsDataView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final currentMaterial = useState<int?>(0);
    final scrollController = useScrollController();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final displayedbacSubjects =
        currentMaterial.value == 0 || currentMaterial.value == null
            ? data.bacSubjects
            : data.bacSubjects
                .where((u) => u.materialId == currentMaterial.value)
                .toList();

    final currentColor = currentMaterial.value == 0
        ? const Color(0xFF00B4D8)
        : data.bacTopics
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
        'مواضيع البكالوريا 🎓',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
          fontFamily: 'SomarSans',
        ),
      ),
      body: Column(
        children: [
          // Filter Section (Premium look)
          Container(
            padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
            child: Column(
              children: [
                FilterSection(
                  items: data.bacTopics,
                  isPremium: false,
                  padding: 8,
                  allLabel: 'جميع الامتحانات',
                  isAllOptionsPressed: currentMaterial.value == 0,
                  onClearAllSelected: () {
                    currentMaterial.value = 0;
                  },
                  labelColor: Colors.white,
                  getLabel: (item) => item.name,
                  selectionExtractor: (item) =>
                      currentMaterial.value == item.id,
                  filterColor: const Color(0xFF00B4D8),
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
                            Icon(Icons.description_outlined, size: 14.sp, color: currentColor),
                            6.horizontalSpace,
                            Text(
                              '${displayedbacSubjects.length} موضوع متاح',
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
                        currentMaterial.value == 0 ? "كل الشعب" : "شعبة محددة",
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
              itemCount: displayedbacSubjects.length,
              itemBuilder: (context, index) {
                final exam = displayedbacSubjects[index];
                final material = data.bacTopics
                    .firstWhere((mat) => mat.id == exam.materialId);

                return GestureDetector(
                  onTap: () {
                    context.pushNamed(AppRoutes.pdfContent.name, extra: {
                      'pdfUrl': exam.pdf,
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
                                exam.name,
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
                                  Icon(Icons.picture_as_pdf_outlined, color: Colors.white.withOpacity(0.8), size: 14.sp),
                                  4.horizontalSpace,
                                  Text(
                                    'عرض الموضوع',
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

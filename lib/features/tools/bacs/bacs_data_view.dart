import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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

    final displayedbacSubjects =
        currentMaterial.value == 0 || currentMaterial.value == null
            ? data.bacSubjects
            : data.bacSubjects
                .where((u) => u.materialId == currentMaterial.value)
                .toList();

    List<Color> headerGradientColors = currentMaterial.value == 0
        ? [Colors.purple.shade700, Colors.deepPurple.shade800]
        : data.bacTopics
            .where((item) => item.id == currentMaterial.value)
            .first
            .colors;

    final currentColor = currentMaterial.value == 0
        ? Colors.purple.shade700
        : data.bacTopics
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
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 26.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'مواضيع البكالوريا',
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
                  // 'مجموعة ${data.bacSubjects.length} امتحان للتحضير',
                  'مواضيع البكالوريا المتاحة',
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
                    items: data.bacTopics,
                    isPremium: false,
                    padding: 0,
                    allLabel: 'جميع الامتحانات',
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
                        Icons.assignment_rounded,
                        size: 18.sp,
                        color: currentColor,
                      ),
                      2.horizontalSpace,
                      Text(
                        '${displayedbacSubjects.length} ${displayedbacSubjects.length == 1 ? 'موضوع' : 'مواضيع'} متاح',
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
                        ? Colors.purple.shade50
                        : data.bacTopics
                            .where((item) => item.id == currentMaterial.value)
                            .first
                            .colors[0]
                            .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    currentMaterial.value == 0
                        ? 'عرض الكل'
                        : data.bacTopics
                            .where((item) => item.id == currentMaterial.value)
                            .first
                            .name,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: currentMaterial.value == 0
                          ? Colors.purple.shade700
                          : data.bacTopics
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
                                      exam.name,
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
                                          'باك',
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

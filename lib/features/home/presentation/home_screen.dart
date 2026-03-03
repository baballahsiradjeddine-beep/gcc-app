import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/features/onboarding/onboarding_notifier.dart';
import 'package:tayssir/providers/data/models/material_model.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/router/bottom_navigation/main_scaffold.dart';
import '../../../providers/data/data_provider.dart';
import '../../../common/core/app_scaffold.dart';
import '../../../router/app_router.dart';
import '../../../common/core/custom_app_bar.dart';
import 'package:tayssir/common/data/configs.dart';
import 'widgets/course_widget.dart';
import 'subscribe_section.dart';
import 'view_style.dart';
import '../../support_chat/presentation/tito_support_fab.dart';
import '../../exercice/presentation/widgets/review_ai_popup.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isGuest = ref.watch(userNotifierProvider).valueOrNull == null;
    final viewStyle = useState<ViewStyle>(isGuest ? ViewStyle.list : ViewStyle.grid);
    final dataState = ref.watch(dataProvider);
    final List<MaterialModel> courses = List.from(dataState.contentData.modules as List<MaterialModel>);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final onboarding = ref.watch(onboardingProvider);
    final configs = ref.watch(configsProvider).valueOrNull;

    // Load data for guest using their division_id
    useEffect(() {
      // If we are a guest, wait until divisionId is set to fetch content
      final shouldFetch = dataState.contentData.modules.isEmpty && (!isGuest || onboarding.divisionId != null);
      if (shouldFetch) {
        Future.microtask(() => ref.read(dataProvider.notifier).getData());
      }
      return null;
    }, [onboarding.divisionId, isGuest]); // Re-run if divisionId is finally set

    // Spotlight the first material if it's the end of the tour
    useEffect(() {
      if (onboarding.tourStep == 5 && courses.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // If the context is still valid, start the showcase
          try {
            ShowCaseWidget.of(context).startShowCase([tourKeyFirstMaterial]);
          } catch (e) {
            // Context might have changed
          }
        });
      }
      return null;
    }, [onboarding.tourStep, courses.length]);

    // Check for AI Review if user is not guest
    useEffect(() {
      if (!isGuest) {
        Future.microtask(() async {
          await ref.read(dataProvider.notifier).checkPendingReviews();
          final count = ref.read(dataProvider).pendingReviewsCount;
          if (count > 0 && context.mounted) {
             showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ReviewAIPopup(count: count),
            );
          }
        });
      }
      return null;
    }, [isGuest]);

    return AppScaffold(
      paddingB: 0,
      paddingX: 0,
      swipeBackEnabled: true,
      topSafeArea: false,
      floatingActionButton: (configs?.titoActive ?? true)
          ? Padding(
              padding: EdgeInsets.only(bottom: 90.h),
              child: const TitoSupportFab(),
            )
          : null,
      extendBody: true,
      bodyBackgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async => ref.read(dataProvider.notifier).refreshData(),
        color: const Color(0xFF00B4D8),
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h, bottom: 16.h), // Standardized spacing
                child: const CustomAppBar(reverse: true),
              ).animate().fadeIn().slideY(begin: -0.1, end: 0),
            ),
            
            SliverToBoxAdapter(
              child: SubscribeSection(),
            ),
            
            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B4D8),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    12.horizontalSpace,
                    Text(
                      "المواد المتاحة :",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        fontFamily: 'SomarSans',
                      ),
                    ),
                    const Spacer(),
                    // Layout Toggle
                    GestureDetector(
                      onTap: () {
                        viewStyle.value = viewStyle.value == ViewStyle.grid 
                            ? ViewStyle.list 
                            : ViewStyle.grid;
                      },
                      child: Container(
                        width: 44.sp,
                        height: 44.sp,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          viewStyle.value == ViewStyle.grid ? Icons.list_rounded : Icons.grid_view_rounded,
                          color: const Color(0xFF00B4D8),
                          size: 26.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),
            ),
            
            // Courses Content
            if (courses.isEmpty && (isGuest && onboarding.divisionId == null))
               const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: Color(0xFF00B4D8)),
                  ),
                ),
              )
            else if (courses.isEmpty)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text(
                      'جاري جلب مواد شعبتك... 🐬',
                      style: TextStyle(fontFamily: 'SomarSans', color: Color(0xFF94A3B8)),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
                sliver: viewStyle.value == ViewStyle.grid
                    ? SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 16.w,
                          childAspectRatio: 1.1, // يجعل المربعات أقصر وأعرض قليلاً لتبدو أرشق
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final card = CardWidget(
                              title: courses[index].title,
                              subTitle: courses[index].description ?? 'أزيد من 300 سؤال\nو 150 تمرين',
                              onPressed: () => _navigateToCourse(context, ref, courses[index]),
                              startColor: _hexToColor(courses[index].gradiantColorStart),
                              endColor: _hexToColor(courses[index].gradiantColorEnd),
                              imageList: courses[index].imageList,
                              imageGrid: courses[index].imageGrid,
                              isGrid: true,
                            ).animate().fadeIn(delay: (300 + index * 50).ms).scale(curve: Curves.easeOutCubic);

                            if (index == 0) {
                              return Showcase(
                                key: tourKeyFirstMaterial,
                                description: 'ممتاز! اختر مادة الآن لتبدأ رحلة النجاح 🚀',
                                descTextStyle: TextStyle(
                                  fontFamily: 'SomarSans',
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                tooltipBackgroundColor: const Color(0xFF0F172A),
                                tooltipPosition: TooltipPosition.bottom,
                                targetBorderRadius: BorderRadius.circular(24.r),
                                overlayOpacity: 0.3,
                                disposeOnTap: true,
                                onTargetClick: () {
                                  _navigateToCourse(context, ref, courses[index]);
                                },
                                child: card,
                              );
                            }
                            return card;
                          },
                          childCount: courses.length,
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final card = CardWidget(
                              title: courses[index].title,
                              subTitle: courses[index].description ?? 'أزيد من 300 سؤال و 150 تمرين',
                              onPressed: () {
                                _navigateToCourse(context, ref, courses[index]);
                              },
                              startColor: _hexToColor(courses[index].gradiantColorStart),
                              endColor: _hexToColor(courses[index].gradiantColorEnd),
                              imageList: courses[index].imageList,
                              imageGrid: courses[index].imageGrid,
                              isGrid: false,
                            ).animate().fadeIn(delay: (300 + index * 50).ms).slideX(begin: 0.1, end: 0, curve: Curves.easeOutCubic);

                            if (index == 0) {
                              return Showcase(
                                key: tourKeyFirstMaterial,
                                description: 'ممتاز! اختر مادة الآن لتبدأ رحلة النجاح 🚀',
                                descTextStyle: TextStyle(
                                  fontFamily: 'SomarSans',
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                tooltipBackgroundColor: const Color(0xFF0F172A),
                                tooltipPosition: TooltipPosition.bottom,
                                targetBorderRadius: BorderRadius.circular(24.r),
                                overlayOpacity: 0.3,
                                disposeOnTap: true,
                                child: card,
                                onTargetClick: () {
                                  _navigateToCourse(context, ref, courses[index]);
                                },
                              );
                            }
                            return card;
                          },
                          childCount: courses.length,
                        ),
                      ),
              ),
            
            SliverToBoxAdapter(child: 120.verticalSpace),
          ],
        ),
      ),
    );
  }

  void _navigateToCourse(BuildContext context, WidgetRef ref, MaterialModel course) {
    context.pushNamed(AppRoutes.units.name, pathParameters: {
      'courseId': course.id.toString(),
    });
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170.h, // تم تقليل الارتفاع من 200 ليكون أكثر رشاقة
      decoration: BoxDecoration(
        color: const Color(0xFF387CA6),
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF387CA6).withOpacity(0.35),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // White Dots Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: CustomPaint(
                painter: _DotPatternPainter(),
              ),
            ),
          ),
          
          // Subtle Top Lighting
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white12, Colors.transparent],
                  stops: [0.0, 0.5],
                ),
              ),
            ),
          ),
          
          // Floating Dolphin and Stars (Matched to HTML placement)
          Positioned(
            left: -15.w,
            top: 20.h,
            bottom: 20.h,
            width: 140.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  "🐬",
                  style: TextStyle(
                    fontSize: 90.sp, 
                    shadows: [
                      Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(5, 5))
                    ]
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true))
                 .moveY(begin: 0, end: -10, duration: 2.seconds, curve: Curves.easeInOut)
                 .rotate(begin: -0.05, end: -0.02, duration: 4.seconds, curve: Curves.easeInOut),
                
                // Stars
                Positioned(
                  top: 25.h,
                  right: 35.w,
                  child: Text("⭐", style: TextStyle(fontSize: 18.sp, color: Colors.yellow.shade300))
                    .animate(onPlay: (c) => c.repeat()).scale(duration: 1.2.seconds, curve: Curves.easeInOut),
                ),
                Positioned(
                  top: 80.h,
                  left: 20.w,
                  child: Text("⭐", style: TextStyle(fontSize: 14.sp, color: Colors.yellow.shade200))
                    .animate(onPlay: (c) => c.repeat(reverse: true)).scale(delay: 600.ms, duration: 1.seconds),
                ),
                Positioned(
                  bottom: 30.h,
                  right: 25.w,
                  child: Text("✨", style: TextStyle(fontSize: 12.sp, color: Colors.white70))
                    .animate(onPlay: (c) => c.repeat()).fadeIn(duration: 2.seconds),
                ),
              ],
            ),
          ),
          
          // Content (Centered but pushed right for the dolphin)
          Padding(
            padding: EdgeInsets.only(right: 24.w, left: 100.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "احصل على جميع\nالدورات والمحتويات\nالمميزة الآن!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 22.sp, 
                    fontWeight: FontWeight.w900, 
                    fontFamily: 'SomarSans', 
                    height: 1.35,
                    shadows: [Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
                  ),
                ),
                20.verticalSpace,
                _buildShineButton("اشترك الآن"),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.96, 0.96), curve: Curves.easeOutBack);
  }

  Widget _buildShineButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF387CA6),
          fontSize: 16.sp,
          fontWeight: FontWeight.w900,
          fontFamily: 'SomarSans',
        ),
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    const spacing = 18.0;
    const radius = 1.2;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Color _hexToColor(String colorStr) {
  String s = colorStr.replaceAll('#', '');
  if (s.length == 6) s = 'FF$s';
  return Color(int.parse(s, radix: 16));
}

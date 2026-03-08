import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import 'package:tayssir/resources/colors/app_colors.dart'; // Force re-import
import '../../ai_planner/presentation/ai_planner_fab.dart';
import '../../ai_planner/presentation/active_plan_overlay.dart';
import '../../ai_planner/presentation/ai_planner_popup.dart';
import '../../ai_planner/state/ai_planner_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  ViewStyle? _viewStyle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final isGuest = ref.read(userNotifierProvider).valueOrNull == null;
        setState(() {
          _viewStyle = isGuest ? ViewStyle.list : ViewStyle.grid;
        });

        // Effect 1: Fetch data
        final dataState = ref.read(dataProvider);
        final onboarding = ref.read(onboardingProvider);
        final shouldFetch = dataState.contentData.modules.isEmpty && (!isGuest || onboarding.divisionId != null);
        if (shouldFetch) {
          ref.read(dataProvider.notifier).getData();
        }

        // Effect 3: Check pending reviews
        if (!isGuest) {
          _checkReviews();
        }
      }
    });
  }

  Future<void> _checkReviews() async {
    await ref.read(dataProvider.notifier).checkPendingReviews();
    final count = ref.read(dataProvider).pendingReviewsCount;
    if (count > 0 && mounted && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ReviewAIPopup(count: count),
      );
    }
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle tour steps if needed
    final onboarding = ref.read(onboardingProvider);
    final courses = ref.read(dataProvider).contentData.modules;
    if (onboarding.tourStep == 5 && courses.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          ShowCaseWidget.of(context).startShowCase([tourKeyFirstMaterial]);
        } catch (e) {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Unified AI Planner listener
    ref.listen<bool>(isFromAiPlannerProvider, (previous, next) {
      if (next == true) {
        // We use a safe delay to ensure navigation has finished and context is stable
        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted || !context.mounted) return;
          
          // Re-check value before resetting to avoid race conditions
          if (ref.read(isFromAiPlannerProvider)) {
            ref.read(isFromAiPlannerProvider.notifier).state = false;
            
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useRootNavigator: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const AIPlannerPopup(),
            );
          }
        });
      }
    });

    final userValue = ref.watch(userNotifierProvider).valueOrNull;
    final isGuest = userValue == null;
    
    // Set default view style if not set yet
    final currentStyle = _viewStyle ?? (isGuest ? ViewStyle.list : ViewStyle.grid);
    
    final dataState = ref.watch(dataProvider);
    final List<MaterialModel> courses = List.from(dataState.contentData.modules as List<MaterialModel>);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final onboarding = ref.watch(onboardingProvider);

    return AppScaffold(
      paddingB: 0,
      paddingX: 0,
      swipeBackEnabled: true,
      topSafeArea: false,
      floatingActionButton: null,
      extendBody: true,
      bodyBackgroundColor: Colors.transparent,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => ref.read(dataProvider.notifier).refreshData(),
            color: const Color(0xFF00B4D8),
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h, bottom: 16.h),
                    child: const CustomAppBar(reverse: true),
                  ).animate().fadeIn().slideY(begin: -0.1, end: 0),
                ),
                
                SliverToBoxAdapter(
                  child: const SubscribeSection(),
                ),
                
                // Header المواد المتاحة
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        12.horizontalSpace,
                        Text(
                          "المواد المتاحة :",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : AppColors.textBlack,
                            fontFamily: 'SomarSans',
                          ),
                        ),
                        const Spacer(),
                        // Layout Toggle
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _viewStyle = currentStyle == ViewStyle.grid 
                                  ? ViewStyle.list 
                                  : ViewStyle.grid;
                            });
                          },
                          child: Container(
                            width: 44.sp,
                            height: 44.sp,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkBlue : AppColors.surfaceWhite,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Icon(
                              currentStyle == ViewStyle.grid ? Icons.list_rounded : Icons.grid_view_rounded,
                              color: AppColors.primaryColor,
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
                        child: CircularProgressIndicator(color: AppColors.primaryColor),
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
                          style: TextStyle(fontFamily: 'SomarSans', color: AppColors.disabledTextColor),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
                    sliver: currentStyle == ViewStyle.grid
                        ? SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16.h,
                              crossAxisSpacing: 16.w,
                              childAspectRatio: 1.1,
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
          const ActivePlanOverlay(),
          const AIPlannerFAB(),
        ],
      ),
    );
  }

  void _navigateToCourse(BuildContext context, WidgetRef ref, MaterialModel course) {
    context.pushNamed(AppRoutes.units.name, pathParameters: {
      'courseId': course.id.toString(),
    });
  }

  Color _hexToColor(String colorStr) {
    String s = colorStr.replaceAll('#', '');
    if (s.length == 6) s = 'FF$s';
    return Color(int.parse(s, radix: 16));
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

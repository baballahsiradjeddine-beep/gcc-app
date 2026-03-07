import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/data/models/material_model.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/common/core/custom_app_bar.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/home/presentation/widgets/course_widget.dart';
import 'package:tayssir/features/home/presentation/view_style.dart';
import 'package:tayssir/features/home/presentation/subscribe_section.dart';
import 'package:tayssir/features/challanges/data/social_repository.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

final friendsProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.watch(socialRepositoryProvider).getFriends();
});

class ChallengeDashboardScreen extends HookConsumerWidget {
  const ChallengeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userNotifierProvider);
    final courses = ref.watch(dataProvider).contentData.modules;
    final viewStyle = useState<ViewStyle>(ViewStyle.grid);

    return AppScaffold(
      paddingB: 0,
      paddingX: 0,
      topSafeArea: false, // Changed to false to match Home Screen's top spacing
      bodyBackgroundColor: const Color(0xFF0B1120),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h, bottom: 16.h),
              child: const CustomAppBar(
              reverse: true,
              showNotifications: false,
              showThemeToggle: false,
              forceDarkMode: true,
            ),
            ).animate().fadeIn().slideY(begin: -0.1, end: 0),
          ),

          // Ads Banner
          const SliverToBoxAdapter(
            child: SubscribeSection(showProgress: false),
          ),

          // Friends Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: _buildFriendsSection(context, ref),
            ),
          ),

          // Section Title with Toggle
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: _buildSectionTitle(context, viewStyle),
            ),
          ),

          // Materials (Synced with Home Style)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
            sliver: viewStyle.value == ViewStyle.grid
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 1.1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return CardWidget(
                          title: courses[index].title,
                          subTitle: courses[index].description ?? 'أزيد من 300 سؤال\nو 150 تمرين',
                          onPressed: () => _showUnitPicker(context, ref, courses[index], _hexToColor(courses[index].gradiantColorStart)),
                          startColor: _hexToColor(courses[index].gradiantColorStart),
                          endColor: _hexToColor(courses[index].gradiantColorEnd),
                          imageList: courses[index].imageList,
                          imageGrid: courses[index].imageGrid,
                          isGrid: true,
                        ).animate().fadeIn(delay: (index * 50).ms).scale(curve: Curves.easeOutCubic);
                      },
                      childCount: courses.length,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return CardWidget(
                          title: courses[index].title,
                          subTitle: courses[index].description ?? 'أزيد من 300 سؤال و 150 تمرين',
                          onPressed: () => _showUnitPicker(context, ref, courses[index], _hexToColor(courses[index].gradiantColorStart)),
                          startColor: _hexToColor(courses[index].gradiantColorStart),
                          endColor: _hexToColor(courses[index].gradiantColorEnd),
                          imageList: courses[index].imageList,
                          imageGrid: courses[index].imageGrid,
                          isGrid: false,
                        ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
                      },
                      childCount: courses.length,
                    ),
                  ),
          ),

          SliverToBoxAdapter(child: 120.verticalSpace),
        ],
      ),
    );
  }

  /* Removed custom header widgets to use CustomAppBar instead */


  Widget _buildFriendsSection(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "الأصدقاء المتصلون 🟢",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'SomarSans',
              ),
            ),
            TextButton(
              onPressed: () => context.pushNamed(AppRoutes.social.name),
              child: Text(
                "عرض الكل",
                style: TextStyle(
                  color: const Color(0xFF00C6E0),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        10.verticalSpace,
        friendsAsync.when(
          data: (friends) {
            if (friends.isEmpty) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.people_outline, color: Colors.white30, size: 30.sp),
                      8.verticalSpace,
                      Text("لا يوجد أصدقاء حالياً", 
                        style: TextStyle(color: Colors.white30, fontSize: 12.sp)),
                    ],
                  ),
                ),
              );
            }
            return SizedBox(
              height: 75.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return Container(
                    margin: EdgeInsets.only(right: 15.w),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF1CB0F6), Color(0xFF00C6E0)],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 24.r,
                            backgroundColor: const Color(0xFF1E293B),
                            backgroundImage: friend['profile_picture'] != null
                                ? CachedNetworkImageProvider(friend['profile_picture'])
                                : null,
                            child: friend['profile_picture'] == null
                                ? const Icon(Icons.person, color: Colors.white54)
                                : null,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          friend['name']?.split(' ')[0] ?? 'لاعب',
                          style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.pink)),
          error: (_, __) => const Text("حدث خطأ في تحميل الأصدقاء", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, ValueNotifier<ViewStyle> viewStyle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
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
    );
  }

  Color _hexToColor(String colorStr) {
    String s = colorStr.replaceAll('#', '');
    if (s.length == 6) s = 'FF$s';
    return Color(int.parse(s, radix: 16));
  }

  void _showUnitPicker(BuildContext context, WidgetRef ref, MaterialModel course, Color themeColor) {
    final units = ref.read(dataProvider).contentData.units.where((u) => u.materialId == course.id).toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: 0.65.sh,
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          border: Border(top: BorderSide(color: Colors.white10, width: 1.5)),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            30.verticalSpace,
            Text(
              'اختر الوحدة ⚔️',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'SomarSans',
                color: const Color(0xFF00C6E0),
                shadows: [
                  Shadow(
                    color: const Color(0xFF00C6E0).withOpacity(0.3),
                    blurRadius: 10,
                  )
                ],
              ),
            ),
            20.verticalSpace,
            Expanded(
              child: units.isEmpty
                  ? const Center(child: Text("لا توجد وحدات", style: TextStyle(color: Colors.white38)))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: units.length,
                      itemBuilder: (context, i) => InkWell(
                        onTap: () {
                          Navigator.pop(ctx);
                          context.pushNamed(AppRoutes.challengeMatchmaking.name, extra: {'unitId': units[i].id, 'courseTitle': course.title});
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                units[i].title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  fontFamily: 'SomarSans',
                                ),
                              ),
                              Icon(Icons.play_circle_fill, color: const Color(0xFF00C6E0), size: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class HexagonShapeBorder extends ShapeBorder {
  const HexagonShapeBorder();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    path.moveTo(rect.center.dx, rect.top);
    path.lineTo(rect.right, rect.top + rect.height * 0.25);
    path.lineTo(rect.right, rect.bottom - rect.height * 0.25);
    path.lineTo(rect.center.dx, rect.bottom);
    path.lineTo(rect.left, rect.bottom - rect.height * 0.25);
    path.lineTo(rect.left, rect.top + rect.height * 0.25);
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

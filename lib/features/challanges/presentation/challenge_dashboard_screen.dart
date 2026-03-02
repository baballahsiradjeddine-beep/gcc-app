import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/data/models/material_model.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/common/core/shield_badge.dart';
import 'package:tayssir/features/home/presentation/subscribe_section.dart';
import 'package:tayssir/features/challanges/data/social_repository.dart';

final friendsProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.watch(socialRepositoryProvider).getFriends();
});

class ChallengeDashboardScreen extends HookConsumerWidget {
  const ChallengeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userNotifierProvider);
    final courses = ref.watch(dataProvider).contentData.modules;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1120),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildExactHeader(context, userAsync),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    10.verticalSpace,
                    const SubscribeSection(),
                    20.verticalSpace,
                    _buildFriendsSection(context, ref),
                    25.verticalSpace,
                    _buildSectionTitle(),
                    15.verticalSpace,
                    _buildSubjectsGrid(context, ref, courses),
                    25.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        ).animate()
            // fadeIn begins at 50ms → at T=350ms (overlay removal) opacity ≈ 86%
            .fadeIn(delay: 50.ms, duration: 350.ms, curve: Curves.easeIn)
            // scale-up starts exactly when overlay lifts → smooth emergence
            .scale(
              begin: const Offset(0.92, 0.92),
              end: const Offset(1.0, 1.0),
              delay: 350.ms,
              duration: 600.ms,
              curve: Curves.easeOutCubic,
            ),
      ),
    );
  }

  Widget _buildExactHeader(BuildContext context, AsyncValue userAsync) {
    final user = userAsync.value;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Styled Text Logo
          RichText(
            text: TextSpan(
              style: TextStyle(fontFamily: 'SomarSans'),
              children: [
                TextSpan(
                  text: 'Tay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: 'ssir',
                  style: TextStyle(
                    color: const Color(0xFF00C6E0),
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 800.ms),

          // Hexagon Profile Badge (Mockup Style)
          _buildHexagonBadge(user),
        ],
      ),
    );
  }

  Widget _buildHexagonBadge(dynamic user) {
    if (user == null) return const SizedBox.shrink();

    final badgeColor = user.badge?.color as String?;
    final themeColor = badgeColor != null
        ? Color(int.parse(badgeColor.replaceAll('#', '0xFF')))
        : const Color(0xFF2DD4BF);
    final badgeIconUrl = user.badge?.completeIconUrl as String?;

    return ShieldBadge(
      userAvatarUrl: user.completeProfilePic,
      badgeIconUrl: badgeIconUrl,
      themeColor: themeColor,
      width: 72,
      height: 90,
      avatarPaddingTop: 20,
      avatarSize: 60,
      avatarOffsetX: -1.5,
    ).animate().scale(begin: const Offset(0.9, 0.9), delay: 200.ms);
  }


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

  Widget _buildSectionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "المواد المتاحة :",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontFamily: 'SomarSans',
          ),
        ),
        // Custom premium dots
        Row(
          children: List.generate(3, (i) => Container(
            margin: EdgeInsets.only(left: 4.w),
            width: 12.w,
            height: 12.w,
            decoration: const BoxDecoration(
              color: Color(0xFF00C6E0),
              shape: BoxShape.circle,
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildSubjectsGrid(BuildContext context, WidgetRef ref, List<MaterialModel> courses) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 20.h,
        childAspectRatio: 0.85,
      ),
      itemCount: courses.length + 1,
      itemBuilder: (context, index) {
        if (index == courses.length) {
          return _buildExactComingSoonCard();
        }
        return _buildExactSubjectCard(context, ref, courses[index], index);
      },
    );
  }

  Widget _buildExactSubjectCard(BuildContext context, WidgetRef ref, MaterialModel course, int index) {
    final List<Map<String, dynamic>> subjectThemes = [
      {'color': const Color(0xFFA855F7), 'border': const Color(0xFF7E22CE), 'icon': '👩‍🎤'},
      {'color': const Color(0xFF1CB0F6), 'border': const Color(0xFF0284C7), 'icon': '🧑‍🏫'},
      {'color': const Color(0xFFEC4899), 'border': const Color(0xFFBE185D), 'icon': '🧕'},
      {'color': const Color(0xFFF59E0B), 'border': const Color(0xFFD97706), 'icon': '👨‍🔬'},
    ];

    final theme = subjectThemes[index % subjectThemes.length];

    return GestureDetector(
      onTap: () => _showUnitPicker(context, ref, course, theme['color']),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme['color'], theme['color'].withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border(
            bottom: BorderSide(color: theme['border'], width: 6),
          ),
          boxShadow: [
            BoxShadow(
              color: theme['color'].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Character Icon (Left)
            Positioned(
              left: -15.w,
              bottom: -5.h,
              child: Text(
                theme['icon'],
                style: TextStyle(fontSize: 80.sp),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: 0, end: -5, duration: 2000.ms),
            ),

            // Text and Button Content (Right)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 115.w,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'SomarSans',
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        6.verticalSpace,
                        Text(
                          "أزيد من 300 سؤال\nو 150 تمرين",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10.sp,
                            fontFamily: 'SomarSans',
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 95.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "إبدأ الآن ⚔️",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SomarSans',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (index * 50).ms).scaleXY(begin: 0.9, end: 1),
    );
  }

  Widget _buildExactComingSoonCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF6B7280),
        borderRadius: BorderRadius.circular(24),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF4B5563), width: 6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Character Icon (Left)
          Positioned(
            left: -15.w,
            bottom: -5.h,
            child: Opacity(
              opacity: 0.5,
              child: Text(
                "🤖",
                style: TextStyle(fontSize: 80.sp),
              ),
            ),
          ),

          // Text and Button Content (Right)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 115.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "بقية المواد",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SomarSans',
                          height: 1.2,
                        ),
                      ),
                      6.verticalSpace,
                      Text(
                        "يتم العمل عليها\nحاليا",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 10.sp,
                          fontFamily: 'SomarSans',
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 95.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "قريبا ...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SomarSans',
                      ),
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

  void _showUnitPicker(BuildContext context, WidgetRef ref, MaterialModel course, Color themeColor) {
    final units = ref.read(dataProvider).contentData.units.where((u) => u.materialId == course.id).toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: 0.6.sh,
        decoration: const BoxDecoration(
          color: Color(0xFF111827),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          border: Border(top: BorderSide(color: Colors.white12, width: 1)),
        ),
        child: Column(
          children: [
            Container(margin: EdgeInsets.symmetric(vertical: 15.h), height: 4, width: 40, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10))),
            Text('اختر الوحدة ⚔️', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'SomarSans')),
            20.verticalSpace,
            Expanded(
              child: units.isEmpty
                  ? const Center(child: Text("لا توجد وحدات", style: TextStyle(color: Colors.white38)))
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: units.length,
                      itemBuilder: (context, i) => InkWell(
                        onTap: () {
                          Navigator.pop(ctx);
                          context.pushNamed(AppRoutes.challengeMatchmaking.name, extra: {'unitId': units[i].id, 'courseTitle': course.title});
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(16.h),
                          decoration: BoxDecoration(color: const Color(0xFF1F2937), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(units[i].title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                              Icon(Icons.play_circle_fill, color: themeColor),
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

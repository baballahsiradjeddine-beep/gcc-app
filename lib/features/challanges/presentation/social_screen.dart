import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/challanges/data/social_repository.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/data/models/material_model.dart';
import 'package:tayssir/features/challanges/data/matchmaking_service.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

final friendsListProvider = FutureProvider<List<dynamic>>((ref) {
  return ref.watch(socialRepositoryProvider).getFriends();
});

final pendingRequestsProvider = FutureProvider<List<dynamic>>((ref) {
  return ref.watch(socialRepositoryProvider).getPendingRequests();
});

class SocialScreen extends ConsumerStatefulWidget {
  const SocialScreen({super.key});

  @override
  ConsumerState<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      bodyBackgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      includeBackButton: true,
      topSafeArea: true,
      // Fixed: Removed paddingX: 0 to restore standard 20.w padding
      paddingB: 0,
      appBar: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'الأصدقاء والبحث',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'SomarSans',
              color: isDark ? Colors.white : AppColors.textBlack,
            ),
          ),
          8.horizontalSpace,
          const Text('🤝', style: TextStyle(fontSize: 20)),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFEC4899),
            unselectedLabelColor: isDark ? Colors.white38 : Colors.black26,
            indicatorColor: const Color(0xFFEC4899),
            indicatorWeight: 3,
            dividerColor: Colors.transparent,
            labelStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'SomarSans',
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'SomarSans',
            ),
            tabs: const [
              Tab(text: 'البحث'),
              Tab(text: 'الطلبات'),
              Tab(text: 'أصدقائي'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                SearchUsersTab(),
                PendingRequestsTab(),
                FriendsListTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchUsersTab extends ConsumerStatefulWidget {
  const SearchUsersTab({super.key});

  @override
  ConsumerState<SearchUsersTab> createState() => _SearchUsersTabState();
}

class _SearchUsersTabState extends ConsumerState<SearchUsersTab> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch(String val) async {
    if (val.length < 2) {
      if (mounted) setState(() => _searchResults = []);
      return;
    }
    if (mounted) setState(() => _isLoading = true);
    try {
      final results = await ref.read(socialRepositoryProvider).searchUsers(val);
      if (mounted) setState(() => _searchResults = results);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (val) => _handleSearch(val),
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textBlack, 
              fontFamily: 'SomarSans', 
              fontWeight: FontWeight.bold
            ),
            decoration: InputDecoration(
              hintText: 'ابحث عن اسم زميلك...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white24 : Colors.black26, 
                fontFamily: 'SomarSans'
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF00C6E0)),
              fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 16.h),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.r), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22.r), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22.r), borderSide: const BorderSide(color: Color(0xFF00C6E0), width: 1.5)),
            ),
          ),
          25.verticalSpace,
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Color(0xFF00C6E0)))
          else
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_rounded, 
                            size: 70.sp, 
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)
                          ),
                          15.verticalSpace,
                          Text(
                            "ابحث عن مستخدمين لتحديهم!", 
                            style: TextStyle(
                              color: isDark ? Colors.white24 : Colors.black26, 
                              fontSize: 14.sp, 
                              fontFamily: 'SomarSans'
                            )
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        return _SocialUserItem(u: _searchResults[index], isSearch: true);
                      },
                    ),
            ),
        ],
      ),
    );
  }
}

class PendingRequestsTab extends ConsumerWidget {
  const PendingRequestsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(pendingRequestsProvider).when(
          data: (requests) {
            if (requests.isEmpty) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Center(child: Text("لا توجد طلبات معلقة 📥", style: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontFamily: 'SomarSans')));
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return _SocialUserItem(u: requests[index]['sender'], isPending: true);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00C6E0))),
          error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
        );
  }
}

class FriendsListTab extends ConsumerWidget {
  const FriendsListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(friendsListProvider).when(
          data: (friends) {
            if (friends.isEmpty) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Center(child: Text("ابدأ بإضافة أصدقاء جدد! 👋", style: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontFamily: 'SomarSans')));
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return _SocialUserItem(u: friends[index], isFriend: true);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00C6E0))),
          error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
        );
  }
}

class _SocialUserItem extends ConsumerWidget {
  final dynamic u;
  final bool isSearch;
  final bool isPending;
  final bool isFriend;

  const _SocialUserItem({
    required this.u,
    this.isSearch = false,
    this.isPending = false,
    this.isFriend = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06), 
          width: 1.5
        ),
      ),
      child: Row(
        children: [
          _buildHexagonAvatar(u['avatar_url'] ?? u['profile_pic']),
          15.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  u['name'] ?? 'مستخدم',
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textBlack, 
                    fontSize: 15.sp, 
                    fontWeight: FontWeight.w900, 
                    fontFamily: 'SomarSans'
                  ),
                ),
                Text(
                  "المستوى: ${u['points'] ?? 0}",
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38, 
                    fontSize: 12.sp, 
                    fontFamily: 'SomarSans'
                  ),
                ),
              ],
            ),
          ),
          if (isSearch)
            _buildActionBtn(context, "إضافة", const Color(0xFF00C6E0), () async {
              await ref.read(socialRepositoryProvider).sendFriendRequest(u['id']);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إرسال طلب الصداقة بنجاح")));
              }
            }),
          if (isPending)
            Row(
              children: [
                _buildActionBtn(context, "قبول", Colors.green, () async {
                  await ref.read(socialRepositoryProvider).acceptFriendRequest(u['id']);
                  ref.invalidate(pendingRequestsProvider);
                  ref.invalidate(friendsListProvider);
                }),
                10.horizontalSpace,
                _buildActionBtn(context, "حذف", Colors.redAccent, () async {
                  await ref.read(socialRepositoryProvider).rejectFriendRequest(u['id']);
                  ref.invalidate(pendingRequestsProvider);
                }),
              ],
            ),
          if (isFriend)
            _buildActionBtn(context, "تحدي ⚔️", const Color(0xFFEC4899), () {
              _showInvitationSettings(context, ref, u);
            }),
        ],
      ),
    ).animate().fadeIn(delay: 50.ms);
  }

  Widget _buildHexagonAvatar(dynamic pic) {
    return Consumer(
      builder: (context, ref, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          width: 52.w,
          height: 58.h,
          decoration: const ShapeDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1CB0F6), Color(0xFF0A66C2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            shape: HexagonShapeBorder(),
          ),
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: ShapeDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: HexagonShapeBorder(),
            ),
            child: ClipPath(
              clipper: _HexagonClipper(),
              child: CachedNetworkImage(
                imageUrl: _getValidUrl(pic),
                fit: BoxFit.cover,
                errorWidget: (c, e, s) => Icon(
                  Icons.person, 
                  color: isDark ? Colors.white10 : Colors.black12
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionBtn(BuildContext context, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color, 
            fontSize: 13.sp, 
            fontWeight: FontWeight.w900, 
            fontFamily: 'SomarSans',
          ),
        ),
      ),
    );
  }

  String _getValidUrl(dynamic avatar) {
    if (avatar == null) return '';
    final url = avatar.toString().trim();
    if (url.startsWith('http')) return url;
    return 'https://gcc.tayssir-bac.com/storage/${url.replaceAll(RegExp(r"^/"), "")}';
  }

  void _showInvitationSettings(BuildContext context, WidgetRef ref, dynamic friend) {
    final courses = ref.read(dataProvider).contentData.modules;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(24.w),
        height: 600.h,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), 
              width: 1
            )
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 50.w, 
              height: 5.h, 
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), 
                borderRadius: BorderRadius.circular(10)
              )
            ),
            30.verticalSpace,
            Text('اختر المادة للتحدي ⚔️',
                style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'SomarSans',
                    color: const Color(0xFFEC4899),
                    shadows: [Shadow(color: const Color(0xFFEC4899).withOpacity(0.3), blurRadius: 10)])),
            20.verticalSpace,
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, i) {
                  final course = courses[i];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      title: Text(course.title,
                          style: TextStyle(
                            color: isDark ? Colors.white : AppColors.textBlack, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 16.sp, 
                            fontFamily: 'SomarSans'
                          )),
                      trailing: Icon(
                        Icons.arrow_back_ios_new, 
                        color: isDark ? Colors.white24 : Colors.black26, 
                        size: 18
                      ),
                      onTap: () {
                        Navigator.pop(ctx);
                        _showUnitSelection(context, ref, friend, course);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUnitSelection(BuildContext context, WidgetRef ref, dynamic friend, MaterialModel course) {
    final units = ref.read(dataProvider).contentData.units.where((u) => u.materialId == course.id).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(24.w),
        height: 600.h,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), 
              width: 1
            )
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 50.w, 
              height: 5.h, 
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), 
                borderRadius: BorderRadius.circular(10)
              )
            ),
            30.verticalSpace,
            Text('اختر المحور للتحدي 🎯',
                style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'SomarSans',
                    color: const Color(0xFF00C6E0),
                    shadows: [Shadow(color: const Color(0xFF00C6E0).withOpacity(0.3), blurRadius: 10)])),
            20.verticalSpace,
            if (units.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Text('لا توجد محاور متاحة حالياً.', style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontFamily: 'SomarSans', fontSize: 14.sp)),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: units.length,
                  itemBuilder: (context, i) {
                    final unit = units[i];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                        title: Text(unit.title, style: TextStyle(color: isDark ? Colors.white : AppColors.textBlack, fontWeight: FontWeight.bold, fontSize: 16.sp, fontFamily: 'SomarSans')),
                        trailing: const Icon(Icons.play_circle_fill, color: Color(0xFF00C6E0), size: 30),
                        onTap: () async {
                          Navigator.pop(ctx);
                          _handleInvite(context, ref, friend, unit, course.title);
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleInvite(BuildContext context, WidgetRef ref, dynamic friend, dynamic unit, String courseTitle) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري تجهيز التحدي وإرسال الدعوة...')));
      }

      final code = await ref.read(matchmakingServiceProvider).createPrivateMatch(unit.id, courseTitle);
      await ref.read(socialRepositoryProvider).sendChallengeInvite(
        receiverId: friend['id'],
        unitId: unit.id,
        courseTitle: courseTitle,
        invitationCode: code,
      );

      if (context.mounted) {
        context.pushNamed(AppRoutes.challengeMatchmaking.name, extra: {
          'unitId': unit.id,
          'courseTitle': courseTitle,
          'initialSearchMode': 'create_private',
          'invitationCode': code,
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width, size.height * 0.25);
    path.lineTo(size.width, size.height * 0.75);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(0, size.height * 0.75);
    path.lineTo(0, size.height * 0.25);
    path.close();
    return path;
  }
  @override bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class HexagonShapeBorder extends ShapeBorder {
  const HexagonShapeBorder();
  @override EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
  @override Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);
  @override Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
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
  @override void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
  @override ShapeBorder scale(double t) => this;
}

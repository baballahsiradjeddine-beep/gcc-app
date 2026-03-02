import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/features/challanges/data/social_repository.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/data/models/material_model.dart';
import 'package:tayssir/features/challanges/data/matchmaking_service.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

final friendsListProvider = FutureProvider<List<dynamic>>((ref) {
  return ref.watch(socialRepositoryProvider).getFriends();
});

final pendingRequestsProvider = FutureProvider<List<dynamic>>((ref) {
  return ref.watch(socialRepositoryProvider).getPendingRequests();
});

class SocialScreen extends HookConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1120),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B1120),
          elevation: 0,
          leading: IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.05),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'الأصدقاء والبحث 🤝',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'SomarSans',
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: tabController,
            labelColor: const Color(0xFFEC4899),
            unselectedLabelColor: Colors.white38,
            indicatorColor: const Color(0xFFEC4899),
            indicatorWeight: 3,
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
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B1120), Color(0xFF0F172A)],
            ),
          ),
          child: TabBarView(
            controller: tabController,
            children: const [
              SearchUsersTab(),
              PendingRequestsTab(),
              FriendsListTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchUsersTab extends HookConsumerWidget {
  const SearchUsersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchResults = useState<List<dynamic>>([]);
    final isLoading = useState(false);

    Future<void> handleSearch(String val) async {
      if (val.length < 2) return;
      isLoading.value = true;
      try {
        final results =
            await ref.read(socialRepositoryProvider).searchUsers(val);
        searchResults.value = results;
      } finally {
        isLoading.value = false;
      }
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (val) => handleSearch(val),
            style: const TextStyle(color: Colors.white, fontFamily: 'SomarSans'),
            decoration: InputDecoration(
              hintText: 'ابحث عن اسم زميلك...',
              hintStyle: const TextStyle(color: Colors.white24, fontFamily: 'SomarSans'),
              prefixIcon: const Icon(Icons.search, color: Color(0xFFEC4899)),
              fillColor: const Color(0xFF1E293B),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            ),
          ),
          20.verticalSpace,
          if (isLoading.value)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: searchResults.value.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 80.sp, color: Colors.white10),
                          10.verticalSpace,
                          Text("ابحث عن مستخدمين لتحديهم!", style: TextStyle(color: Colors.white24, fontSize: 14.sp, fontFamily: 'SomarSans')),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: searchResults.value.length,
                      itemBuilder: (context, index) {
                        final u = searchResults.value[index];
                        return _buildUserListItem(u, ref, context, isSearch: true);
                      },
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserListItem(dynamic u, WidgetRef ref, BuildContext context, {bool isSearch = false, bool isPending = false, bool isFriend = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
                  style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w900, fontFamily: 'SomarSans'),
                ),
                Text(
                  "المستوى: ${u['points'] ?? 0}",
                  style: TextStyle(color: Colors.white38, fontSize: 12.sp, fontFamily: 'SomarSans'),
                ),
              ],
            ),
          ),
          if (isSearch)
            _buildActionBtn("إضافة", const Color(0xFF00C6E0), () async {
              await ref.read(socialRepositoryProvider).sendFriendRequest(u['id']);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إرسال طلب الصداقة بنجاح")));
            }),
          if (isPending)
            Row(
              children: [
                _buildActionBtn("قبول", Colors.green, () async {
                  await ref.read(socialRepositoryProvider).acceptFriendRequest(u['id']);
                  ref.invalidate(pendingRequestsProvider);
                  ref.invalidate(friendsListProvider);
                }),
                10.horizontalSpace,
                _buildActionBtn("حذف", Colors.redAccent, () async {
                  await ref.read(socialRepositoryProvider).rejectFriendRequest(u['id']);
                  ref.invalidate(pendingRequestsProvider);
                }),
              ],
            ),
          if (isFriend)
            _buildActionBtn("تحدي ⚔️", const Color(0xFFEC4899), () {
              _showInvitationSettings(context, ref, u);
            }),
        ],
      ),
    ).animate().fadeIn(delay: 50.ms);
  }

  Widget _buildHexagonAvatar(dynamic pic) {
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
        decoration: const ShapeDecoration(
          color: Color(0xFF1E293B),
          shape: HexagonShapeBorder(),
        ),
        child: ClipPath(
          clipper: _HexagonClipper(),
          child: CachedNetworkImage(
            imageUrl: _getValidUrl(pic),
            fit: BoxFit.cover,
            errorWidget: (c, e, s) => const Icon(Icons.person, color: Colors.white10),
          ),
        ),
      ),
    );
  }

  Widget _buildActionBtn(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.bold, fontFamily: 'SomarSans'),
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

  void _showInvitationSettings(
      BuildContext context, WidgetRef ref, dynamic friend) {
    final courses = ref.read(dataProvider).contentData.modules;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(24.w),
        height: 600.h,
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          border: Border(top: BorderSide(color: Colors.white10, width: 1)),
        ),
        child: Column(
          children: [
            Container(width: 50.w, height: 5.h, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10))),
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
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      title: Text(course.title,
                          style: TextStyle(
                              color: Colors.white, 
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              fontFamily: 'SomarSans')),
                      trailing: const Icon(Icons.arrow_back_ios_new, color: Colors.white24, size: 18),
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

  void _showUnitSelection(BuildContext context, WidgetRef ref, dynamic friend,
      MaterialModel course) {
    final units = ref
        .read(dataProvider)
        .contentData
        .units
        .where((u) => u.materialId == course.id)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(24.w),
        height: 600.h,
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          border: Border(top: BorderSide(color: Colors.white10, width: 1)),
        ),
        child: Column(
          children: [
            Container(width: 50.w, height: 5.h, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10))),
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
                child: Text('لا توجد محاور متاحة حالياً.', style: TextStyle(color: Colors.white38, fontFamily: 'SomarSans', fontSize: 14.sp)),
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
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                        title: Text(unit.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp, fontFamily: 'SomarSans')),
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

  Future<void> _handleInvite(BuildContext context, WidgetRef ref,
      dynamic friend, dynamic unit, String courseTitle) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('جاري تجهيز التحدي وإرسال الدعوة...')));

      final matchmaking = ref.read(matchmakingServiceProvider);
      final social = ref.read(socialRepositoryProvider);

      // 1. Create Private Match
      final code = await matchmaking.createPrivateMatch(unit.id, courseTitle);

      // 2. Send Invitation Push
      await social.sendChallengeInvite(
        receiverId: friend['id'],
        unitId: unit.id,
        courseTitle: courseTitle,
        invitationCode: code,
      );

      // 3. Go to Matchmaking Screen
      if (context.mounted) {
        context.pushNamed(
          AppRoutes.challengeMatchmaking.name,
          extra: {
            'unitId': unit.id,
            'courseTitle': courseTitle,
            'initialSearchMode': 'create_private',
            'invitationCode': code,
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }
}
class PendingRequestsTab extends HookConsumerWidget {
  const PendingRequestsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchUsersTab = SearchUsersTab();
    return ref.watch(pendingRequestsProvider).when(
          data: (requests) {
            if (requests.isEmpty) {
              return const Center(child: Text("لا توجد طلبات معلقة 📥", style: TextStyle(color: Colors.white24, fontFamily: 'SomarSans')));
            }
            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return searchUsersTab._buildUserListItem(requests[index]['sender'], ref, context, isPending: true);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        );
  }
}

class FriendsListTab extends HookConsumerWidget {
  const FriendsListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchUsersTab = SearchUsersTab();
    return ref.watch(friendsListProvider).when(
          data: (friends) {
            if (friends.isEmpty) {
              return const Center(child: Text("ابدأ بإضافة أصدقاء جدد! 👋", style: TextStyle(color: Colors.white24, fontFamily: 'SomarSans')));
            }
            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return searchUsersTab._buildUserListItem(friends[index], ref, context, isFriend: true);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        );
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

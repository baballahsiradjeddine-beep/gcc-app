import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/app_buttons/app_button.dart';
import 'package:tayssir/features/challanges/data/social_repository.dart';

class SocialScreen extends HookConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    
    return AppScaffold(
      topSafeArea: true,
      isScroll: false,
      appBar: AppBar(
        title: Text('الأصدقاء والبحث 🤝', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.pink,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.pink,
          tabs: const [
            Tab(text: 'البحث'),
            Tab(text: 'الطلبات'),
            Tab(text: 'أصدقائي'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          SearchUsersTab(),
          PendingRequestsTab(),
          FriendsListTab(),
        ],
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
        final results = await ref.read(socialRepositoryProvider).searchUsers(val);
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
            decoration: InputDecoration(
              hintText: 'ابحث عن اسم زميلك...',
              prefixIcon: const Icon(Icons.search),
              fillColor: Colors.grey[100],
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            ),
          ),
          20.verticalSpace,
          if (isLoading.value)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.value.length,
                itemBuilder: (context, index) {
                  final user = searchResults.value[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 10.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user['avatar_url'] ?? 'https://via.placeholder.com/150'),
                      ),
                      title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user['friendship_status'] == 'none' ? 'ليس في قائمة الأصدقاء' : user['friendship_status']),
                      trailing: _buildActionButton(context, ref, user),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, WidgetRef ref, dynamic user) {
    if (user['friendship_status'] == 'none') {
      return SmallButton(
        text: 'إضافة',
        onPressed: () async {
          await ref.read(socialRepositoryProvider).sendFriendRequest(user['id']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال طلب الصداقة')));
        },
      );
    } else if (user['friendship_status'] == 'pending') {
      return Text(user['is_sender'] ? 'تم الإرسال' : 'بانتظار قبولك', style: const TextStyle(color: Colors.orange));
    } else {
      return const Icon(Icons.check_circle, color: Colors.green);
    }
  }
}

class PendingRequestsTab extends HookConsumerWidget {
  const PendingRequestsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = useState<List<dynamic>>([]);
    final isLoading = useState(true);

    Future<void> fetchRequests() async {
      isLoading.value = true;
      try {
        final data = await ref.read(socialRepositoryProvider).getPendingRequests();
        requests.value = data;
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchRequests();
      return null;
    }, []);

    if (isLoading.value) return const Center(child: CircularProgressIndicator());

    if (requests.value.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_disabled, size: 60.sp, color: Colors.grey),
            10.verticalSpace,
            const Text('لا يوجد طلبات معلقة حالياً'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: requests.value.length,
      itemBuilder: (context, index) {
        final req = requests.value[index];
        final sender = req['sender'];
        return Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(sender['avatar_url'] ?? 'https://via.placeholder.com/150')),
            title: Text(sender['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('يريد أن يصبح صديقك'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () async {
                    await ref.read(socialRepositoryProvider).acceptFriendRequest(req['id']);
                    fetchRequests();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () async {
                    await ref.read(socialRepositoryProvider).rejectFriendRequest(req['id']);
                    fetchRequests();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FriendsListTab extends HookConsumerWidget {
  const FriendsListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friends = useState<List<dynamic>>([]);
    final isLoading = useState(true);

    Future<void> fetchFriends() async {
      isLoading.value = true;
      try {
        final data = await ref.read(socialRepositoryProvider).getFriends();
        friends.value = data;
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchFriends();
      return null;
    }, []);

    if (isLoading.value) return const Center(child: CircularProgressIndicator());

    if (friends.value.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 60.sp, color: Colors.grey),
            10.verticalSpace,
            const Text('قائمة أصدقائك فارغة، ابدأ بالبحث والإضافة!'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: friends.value.length,
      itemBuilder: (context, index) {
        final friend = friends.value[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(friend['avatar_url'] ?? 'https://via.placeholder.com/150')),
            title: Text(friend['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: SmallButton(
              text: 'تحدي ⚔️',
              color: Colors.blue,
              onPressed: () {
                // Here we could implement direct invitation
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ميزة الدعوة المباشرة قيد التطوير')));
              },
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/features/tools/tools_screen.dart';

import '../../features/challanges/challenges_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/leaderboard/leaderboard_screen.dart';
import '../../common/coming_soon_screen.dart';
import '../../resources/resources.dart';
import 'nav_item.dart';
import 'nav_item_model.dart';

final navItemsProvider = Provider<List<NavItemModel>>((ref) {
  return [
    NavItemModel(
        index: 0, icon: SVGs.icBox, label: 'أدوات', page: const ToolsScreen()),
    NavItemModel(
        index: 1,
        icon: SVGs.icLeaderboard,
        label: 'ترتيب',
        page: const LeaderboardScreen()),
    NavItemModel(
        index: 2, icon: SVGs.icHome, label: 'تعلم', page: const HomeScreen()),
    NavItemModel(
        index: 3,
        icon: SVGs.icRace,
        label: 'تحديات',
        page: const ChallengesScreen()),
    NavItemModel(
        index: 4,
        icon: SVGs.icSettings,
        label: 'إعدادات',
        page: const ComingSoonScreen()),
  ];
});

class CustomBottomNavBarWidget extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 65.h,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ...ref.watch(navItemsProvider).map((item) {
          return NavItem(
            ontap: onTap,
            isSelected: currentIndex == item.index,
            index: item.index,
            icon: item.icon,
            label: item.label,
          );
        }),
      ]),
    );
  }
}

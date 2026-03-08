import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/tools/card_swipper/state/card_swipper_controller.dart';
import 'package:tayssir/features/tools/card_swipper/category_filter_section.dart';
import 'package:tayssir/features/tools/card_swipper/topic_card.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/services/actions/dialog_service.dart';

class CardSwipperScreen extends HookConsumerWidget {
  const CardSwipperScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardDataAsync = ref.watch(cardSwipperControllerProvider);
    final state = ref.watch(cardDataProvider);

    return state.when(
      loading: () => const CardSwipperLoadingView(),
      error: (error, stack) => AppScaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
              SizedBox(height: 16.h),
              Text(
                'حدث خطأ في تحميل البيانات',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                error.toString(),
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      data: (state) => const CardSwipperDataView(),
    );
  }
}

class CardSwipperLoadingView extends StatelessWidget {
  const CardSwipperLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      paddingX: 0,
      paddingY: 0,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Text(
                  'بطاقات بيان',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1E293B),
                    fontFamily: 'SomarSans',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                margin:
                    EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 8.0.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? const Color(0xFF1E293B) 
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18.sp,
                      height: 18.sp,
                      child: const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00B4D8)),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'جاري تحميل البطاقات...',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SomarSans',
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? const Color(0xFF94A3B8) 
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.blue.shade700,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'جاري تحميل البطاقات...',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardSwipperDataView extends HookConsumerWidget {
  const CardSwipperDataView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cardSwipperControllerProvider);
    final filteredTopics = state.currentCards;
    final topics = state.allTopics;
    final currentColor = state.topicColors.first;
    final categories = state.currentCategories;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final swipeCount = useState<int>(0);

    return AppScaffold(
      includeBackButton: true,
      topSafeArea: true,
      paddingX: 0,
      paddingY: 0,
      paddingB: 0,
      bodyBackgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: Text(
        'بطاقات بيان 🔖',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
          fontFamily: 'SomarSans',
        ),
      ),
      body: Column(
        children: [
          // Topics Filter
          12.verticalSpace,
          FilterSection(
            items: topics,
            isPremium: true,
            allLabel: 'الكل',
            padding: 8,
            onItemPressed: (item) {
              ref
                  .read(cardSwipperControllerProvider.notifier)
                  .selectTopic(item.id);
            },
            onClearAllSelected: () {
              ref
                  .read(cardSwipperControllerProvider.notifier)
                  .resetFilters();
            },
            filterColor: const Color(0xFF00B4D8),
            getLabel: (item) {
              return item.name;
            },
            isAllOptionsPressed: !state.isTopicSelected,
            selectionExtractor: (item) {
              return state.isTopicIdSelected(item.id);
            },
          ),
          
          // Categories Filter (Animated)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: categories.isEmpty ? 0.h : 45.h,
            child: categories.isEmpty
                ? const SizedBox.shrink()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemBuilder: (context, index) {
                      final isAllChip = index == 0;
                      const isSub = true;
                      final isSelected = isAllChip
                          ? ref
                                  .watch(cardSwipperControllerProvider)
                                  .selectedCategoryId ==
                              null
                          : ref
                                  .watch(cardSwipperControllerProvider)
                                  .selectedCategoryId ==
                              categories[index - 1].id;
                      final chipText =
                          isAllChip ? 'الكل' : categories[index - 1].name;

                      return Padding(
                        padding: EdgeInsets.only(right: 8.w, bottom: 8.h),
                        child: FilterChip(
                          label: Text(
                            chipText,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? const Color(0xFF94A3B8) : Colors.black87),
                              fontSize: 13.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w900
                                  : FontWeight.normal,
                              fontFamily: 'SomarSans',
                            ),
                          ),
                          selected: isSelected,
                          showCheckmark: false,
                          selectedColor: currentColor,
                          backgroundColor: isDark 
                              ? const Color(0xFF1E293B) 
                              : Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.transparent
                                  : (isDark ? const Color(0xFF334155) : Colors.grey.shade300),
                              width: 1,
                            ),
                          ),
                          onSelected: (_) {
                            if (isAllChip) {
                              ref
                                  .read(cardSwipperControllerProvider
                                      .notifier)
                                  .selectCategory(null);
                            } else if (isSub) {
                              ref
                                  .read(cardSwipperControllerProvider
                                      .notifier)
                                  .selectCategory(
                                      categories[index - 1].id);
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),

          // Count Indicator
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: currentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: currentColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome_motion_rounded,
                  size: 16.sp,
                  color: currentColor,
                ),
                10.horizontalSpace,
                Text(
                  (ref.watch(userNotifierProvider).valueOrNull?.isSub == true)
                      ? '${filteredTopics.length} بطاقة للمراجعة'
                      : 'لديك ${filteredTopics.length} بطاقات مجانية',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color: currentColor,
                    fontFamily: 'SomarSans',
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),

          Expanded(
            child: filteredTopics.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64.sp,
                          color: isDark ? const Color(0xFF475569) : Colors.grey.shade400,
                        ),
                        16.verticalSpace,
                        Text(
                          'لا توجد بطاقات متاحة حالياً',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'SomarSans',
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF64748B) : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : CardSwiper(
                    controller: state.cardController,
                    cardsCount: filteredTopics.length,
                    numberOfCardsDisplayed: filteredTopics.length >= 3
                        ? 3
                        : filteredTopics.length,
                    backCardOffset: const Offset(25, 15),
                    padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                    isLoop: true,
                    onSwipe: (previousIndex, currentIndex, direction) {
                      swipeCount.value++;
                      return true;
                    },
                    cardBuilder: (context, index, percentThresholdX,
                        percentThresholdY) {
                      final topic = filteredTopics[index];
                      return TopicCard(
                        item: topic,
                        index: index,
                      );
                    },
                  ),
          ),

          // Control Buttons
          Padding(
            padding: EdgeInsets.only(bottom: 30.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (filteredTopics.isNotEmpty)
                  _buildMiniFab(
                    Icons.arrow_back_rounded,
                    currentColor,
                    () => ref.read(cardSwipperControllerProvider.notifier).swipeRight(),
                  ),
                25.horizontalSpace,
                if (filteredTopics.isNotEmpty)
                  _buildMiniFab(
                    Icons.shuffle_rounded,
                    (ref.watch(userNotifierProvider).valueOrNull?.isSub != true)
                        ? Colors.grey
                        : currentColor,
                    () {
                      final isSub = ref.watch(userNotifierProvider).valueOrNull?.isSub ?? false;
                      if (!isSub) {
                        DialogService.showNeedSubscriptionDialog(context);
                      } else {
                        ref.read(cardSwipperControllerProvider.notifier).shuffleCards();
                      }
                    },
                  ),
                25.horizontalSpace,
                if (filteredTopics.isNotEmpty)
                  _buildMiniFab(
                    Icons.arrow_forward_rounded,
                    currentColor,
                    () => ref.read(cardSwipperControllerProvider.notifier).swipeLeft(),
                  ),
              ],
            ),
          ).animate().slideY(begin: 0.2, end: 0, delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildMiniFab(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22.sp),
      ),
    );
  }
}

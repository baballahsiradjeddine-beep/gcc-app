import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                    color: Colors.black87,
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
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18.sp,
                      height: 18.sp,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'جاري تحميل البطاقات...',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
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

    final swipeCount = useState<int>(0);

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
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              FilterSection(
                items: topics,
                isPremium: true,
                allLabel: 'الكل',
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
                filterColor: state.topicColors.first,
                getLabel: (item) {
                  return item.name;
                },
                isAllOptionsPressed: !state.isTopicSelected,
                selectionExtractor: (item) {
                  return state.isTopicIdSelected(item.id);
                },
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: categories.isEmpty ? 0.h : 37.h,
                margin: EdgeInsets.symmetric(vertical: 0.h),
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
                            padding: EdgeInsets.only(right: 8.w),
                            child: AnimatedScale(
                              scale: isSelected ? 1.05 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: FilterChip(
                                label: Text(
                                  chipText,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 14.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                selected: isSelected,
                                showCheckmark: false,
                                selectedColor: currentColor,
                                backgroundColor: Colors.grey.shade100,
                                shadowColor:
                                    currentColor.withValues(alpha: 0.3),
                                elevation: isSelected ? 3 : 0,
                                pressElevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 2.h),
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
                            ),
                          );
                        },
                      ),
              ),
              Container(
                margin:
                    EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 8.0.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: currentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18.sp,
                      color: currentColor,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      (ref.watch(userNotifierProvider).valueOrNull?.isSub == true)
                          ? '${filteredTopics.length} ${filteredTopics.length == 1 ? 'بطاقة' : 'بطاقات'} للمراجعة'
                          : 'لديك فقط ${filteredTopics.length} ${filteredTopics.length == 1 ? 'بطاقة' : 'بطاقات'} في الخطة المجانية',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: currentColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredTopics.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64.sp,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'لا توجد مواضيع في هذه الفئة',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            8.horizontalSpace,
                            ElevatedButton.icon(
                              onPressed: () {
                                ref
                                    .read(
                                        cardSwipperControllerProvider.notifier)
                                    .resetFilters();
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('عرض كل المواضيع'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade500,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
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
                        padding: EdgeInsets.all(24.0.r),
                        isLoop: true,
                        initialIndex: 0,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (filteredTopics.isNotEmpty)
                    FloatingActionButton(
                      heroTag: 'swipeRight',
                      onPressed: () {
                        ref
                            .read(cardSwipperControllerProvider.notifier)
                            .swipeRight();
                      },
                      backgroundColor: currentColor,
                      mini: true,
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  20.horizontalSpace,
                  if (filteredTopics.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          heroTag: 'shuffle',
                          onPressed: () {
                            final isSub = ref.watch(userNotifierProvider).valueOrNull?.isSub ?? false;
                            if (!isSub) {
                              DialogService.showNeedSubscriptionDialog(context);
                            } else {
                              ref.read(cardSwipperControllerProvider.notifier).shuffleCards();
                            }
                          },
                          backgroundColor: (ref.watch(userNotifierProvider).valueOrNull?.isSub != true)
                              ? Colors.grey.shade400
                              : currentColor,
                          mini: true,
                          child: const Icon(Icons.shuffle_rounded, color: Colors.white),
                        ),
                        SizedBox(width: 8.w),
                        FloatingActionButton(
                          heroTag: 'reverseShuffle',
                          onPressed: () {
                            final isSub = ref.watch(userNotifierProvider).valueOrNull?.isSub ?? false;
                            if (!isSub) {
                              DialogService.showNeedSubscriptionDialog(context);
                            } else {
                              ref.read(cardSwipperControllerProvider.notifier).reverseShuffleCards();
                            }
                          },
                          backgroundColor: (ref.watch(userNotifierProvider).valueOrNull?.isSub != true)
                              ? Colors.grey.shade400
                              : currentColor,
                          mini: true,
                          child: const Icon(Icons.sort_rounded, color: Colors.white),
                        ),
                      ],
                    ),
                  20.horizontalSpace,
                  if (filteredTopics.isNotEmpty)
                    FloatingActionButton(
                      heroTag: 'swipeLeft',
                      onPressed: () {
                        ref
                            .read(cardSwipperControllerProvider.notifier)
                            .swipeLeft();
                      },
                      backgroundColor: currentColor,
                      mini: true,
                      child:
                          const Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

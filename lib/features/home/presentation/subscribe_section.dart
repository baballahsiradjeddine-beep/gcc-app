import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/subscribe_button.dart';
import 'package:tayssir/features/home/data/banners/banner_repository.dart';
import 'package:tayssir/features/home/presentation/banner_model.dart';
import 'package:tayssir/features/home/presentation/banner_widget.dart';
import 'package:tayssir/features/home/presentation/user_progress_widget.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:carousel_slider/carousel_slider.dart';

final bannerItemsProvider = FutureProvider<List<BannerModel>>((ref) async {
  // Don't fetch banners if user is not authenticated (guest/tour mode)
  final user = ref.watch(userNotifierProvider).valueOrNull;
  if (user == null) return [];

  final res = await ref.watch(bannerRepositoryProvider).getBanners();
  return res;
});

class SubscribeSection extends ConsumerStatefulWidget {
  final bool showProgress;
  const SubscribeSection({super.key, this.showProgress = true});

  @override
  ConsumerState<SubscribeSection> createState() => _SubscribeSectionState();
}

class _SubscribeSectionState extends ConsumerState<SubscribeSection> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // We don't use the state anymore as it's purely for the carousel UI, 
    // but we can keep it in class state for consistency.
    
    final bannerAsync = ref.watch(bannerItemsProvider);
    final user = ref.watch(userNotifierProvider).valueOrNull;
    final isLoading = bannerAsync.isLoading;
    
    final List<Widget> items = [
      if (user?.isSub != true)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: const SubscribeButton(),
        ),
      if (!isLoading)
        ...bannerAsync.valueOrNull?.map((banner) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: BannerWidget(
              title: banner.title,
              description: banner.description,
              actionUrl: banner.actionUrl,
              gradientStart: banner.gradientStart,
              gradientEnd: banner.gradientEnd,
              image: banner.image,
            ),
          );
        }) ?? [],
      if (widget.showProgress) 
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: const UserProgressWidget(),
        ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        bannerAsync.when(
          data: (banners) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                height: 130.h,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    CarouselSlider(
                      key: ValueKey('carousel_${items.length}'), 
                      items: items,
                      options: CarouselOptions(
                        height: 128.h,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        enableInfiniteScroll: items.length > 1,
                        autoPlayInterval: const Duration(seconds: 4),
                        onPageChanged: (i, _) {
                          if (mounted) {
                            setState(() {
                              _currentIndex = i;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
        ),
      ],
    );
  }
}

class SliderIndicator extends StatelessWidget {
  const SliderIndicator(
      {super.key,
      required this.itemsCount,
      required this.itemIndex,
      required this.selectedChild,
      required this.unselectedChild});
  final int itemsCount;
  final int itemIndex;
  final Widget selectedChild;
  final Widget unselectedChild;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Keep indicators compact
      children: [
        ...List.generate(itemsCount, (index) {
          bool isSelected = index == itemIndex;

          return isSelected ? selectedChild : unselectedChild;
        })
      ],
    );
  }
}

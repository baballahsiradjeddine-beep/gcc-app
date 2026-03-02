import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

// final carouselItemsProvider = Provider<List<Widget>>((ref) {
//   final user = ref.watch(userNotifierProvider).requireValue;
//   if (user == null) {
//     return [];
//   }
//   final List<Widget> items = [];

//   // Add subscribe button for non-subscribers
//   if (!user.isSub) {
//     items.add(
//       const SubscribeButton(),
//     );
//   }

//   items.add(
//     const UserProgressWidget(
//         // courses: [],
//         ),
//   );

//   return items;
// });

class SubscribeSection extends HookConsumerWidget {
  const SubscribeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = useState<int>(0);

    // final items = ref.watch(carouselItemsProvider);
    final isLoading = ref.watch(bannerItemsProvider).isLoading;
    final List<Widget> items = [
      if (ref.watch(userNotifierProvider).valueOrNull?.isSub != true)
        const SubscribeButton(),
      if (!isLoading)
        ...ref.watch(bannerItemsProvider).valueOrNull?.map((banner) {
          return BannerWidget(
            title: banner.title,
            description: banner.description,
            actionUrl: banner.actionUrl,
            gradientStart: banner.gradientStart,
            gradientEnd: banner.gradientEnd,
            image: banner.image,
          );
        }) ?? [],
      const UserProgressWidget(),
    ];

    return items.isNotEmpty
        ? Column(
            children: [
              ref.watch(bannerItemsProvider).when(
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
                                  onPageChanged: (i, _) => index.value = i,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Center(
                      child: Text(error.toString()),
                    ),
                  ),
            ],
          )
        : const SizedBox.shrink();
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

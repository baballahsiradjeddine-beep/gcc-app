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
  // Simulate fetching banners from an API or database
  final res = await ref.watch(bannerRepositoryProvider).getBanners();

  // // Example banners
  // return [
  //   const BannerModel(
  //     id: 1,
  //     title: 'Welcome to Tayssir',
  //     description: 'Your journey to learning starts here.',
  //     actionUrl: '/subscribe',
  //     actionLabel: 'Subscribe Now',
  //     gradientStart: '#FF5733',
  //     gradientEnd: '#FFC300',
  //     image: 'https://example.com/image1.png',
  //     createdAt: '2023-10-01T00:00:00Z',
  //   ),
  //   const BannerModel(
  //     id: 2,
  //     title: 'New Courses Available',
  //     description: 'Check out our latest courses and start learning today.',
  //     actionUrl: '/courses',
  //     actionLabel: 'View Courses',
  //     gradientStart: '#33FF57',
  //     gradientEnd: '#C300FF',
  //     image: 'https://example.com/image2.png',
  //     createdAt: '2023-10-02T00:00:00Z',
  //   ),
  // ];
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
      if (!ref.watch(userNotifierProvider).requireValue!.isSub)
        const SubscribeButton(),
      if (!isLoading)
        ...ref.watch(bannerItemsProvider).requireValue.map((banner) {
          return BannerWidget(
            title: banner.title,
            description: banner.description,
            actionUrl: banner.actionUrl,
            gradientStart: banner.gradientStart,
            gradientEnd: banner.gradientEnd,
            image: banner.image,
          );
        }),
      const UserProgressWidget(),
    ];

    return items.isNotEmpty
        ? Column(
            children: [
              10.verticalSpace,
              ref.watch(bannerItemsProvider).when(
                    data: (banners) {
                      return Directionality(
                        textDirection: TextDirection.ltr,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            CarouselSlider(
                              items: items,
                              options: CarouselOptions(
                                height: 125.h,
                                viewportFraction: 0.96,
                                autoPlay: true,
                                enableInfiniteScroll: items.length > 1,
                                autoPlayInterval: const Duration(seconds: 3),
                                onPageChanged: (i, _) => index.value = i,
                              ),
                            ),
                            // if (banners.isNotEmpty)
                            //   Padding(
                            //     padding:
                            //         EdgeInsets.only(left: 30.w, bottom: 15.h),
                            //     child: SliderIndicator(
                            //       itemsCount: items.length,
                            //       itemIndex: index.value,
                            //       selectedChild: Container(
                            //         margin: const EdgeInsets.only(right: 10),
                            //         width: 37,
                            //         height: 2,
                            //         decoration: const BoxDecoration(
                            //             color: Colors.white),
                            //       ),
                            //       unselectedChild: Container(
                            //         margin: const EdgeInsets.only(right: 10),
                            //         width: 10,
                            //         height: 2,
                            //         decoration:
                            //             const BoxDecoration(color: Colors.grey),
                            //       ),
                            //     ),
                            // ),
                          ],
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
      children: [
        ...List.generate(itemsCount, (index) {
          bool isSelected = index == itemIndex;

          return isSelected ? selectedChild : unselectedChild;
        })
      ],
    );
  }
}

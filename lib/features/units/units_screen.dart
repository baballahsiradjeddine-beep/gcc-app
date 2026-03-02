import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/core/custom_app_bar.dart';
import 'package:tayssir/features/chapters/widgets/custom_lesson_widget.dart';
import 'package:tayssir/features/home/presentation/subscribe_section.dart';
import 'package:tayssir/features/units/empty_content_widget.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/services/actions/dialog_service.dart';

import '../../providers/data/data_provider.dart';
import '../exercice/presentation/state/exercice_controller.dart';
import 'widgets/unit_progress_widget.dart';
import 'package:tayssir/features/support_chat/presentation/tito_support_fab.dart';

class UnitsScreen extends HookConsumerWidget {
  const UnitsScreen({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSub = ref.watch(userNotifierProvider).valueOrNull?.isSub ?? false;
    final state = ref.watch(dataProvider);
    final units = state.getUnitsByCourseId(courseId);
    final material = state.getMaterialById(courseId);

    final scrollOffset = useState<double>(0.0);

    if (units.isEmpty) {
      return const EmptyContentWidget(
        message: 'سيتم اضافة محاور  قريبا',
      );
    }
    return AppScaffold(
        paddingB: 0,
        paddingX: 0,
        swipeBackEnabled: true,
        topSafeArea: false,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 90.h),
          child: const TitoSupportFab(),
        ),
        appBar: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h, bottom: 16.h),
          child: const CustomAppBar(reverse: true),
        ),
        body: Column(
          children: [
            // Fixed top section with dynamic shadow based on scroll
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: scrollOffset.value > 10 ? 0.08 : 0),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const SubscribeSection(),
            ),
            Expanded(
              child: Stack(
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification) {
                        scrollOffset.value = notification.metrics.pixels;
                      }
                      return true;
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 1.h),
                            child: TayssirProgressWidget(
                              name: material.description,
                              progress: material.progress,
                              upperText: material.title,
                              direction: material.direction,
                              startColor: _hexToColor(material.gradiantColorStart),
                              endColor: _hexToColor(material.gradiantColorEnd),
                              imageUrl: material.imageList,
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          sliver: Directionality(
                            textDirection: material.direction,
                            child: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final isCurrent = state.isCurrentUnit(units[index].id, courseId);
                                  final isPremiumUnit = state.isPremiumUnit(units[index].id);
                                  
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4.h),
                                    child: CustomLessonWidget(
                                      onPressed: isPremiumUnit && !isSub
                                          ? () => DialogService.showNeedSubscriptionDialog(context)
                                          : () {
                                              ref.read(currentUnitIdProvider.notifier).state = units[index].id;
                                              context.pushNamed(
                                                AppRoutes.chapters.name,
                                                pathParameters: {'unitId': units[index].id.toString()},
                                              );
                                            },
                                      imageUrl: units[index].image,
                                      progress: units[index].progress,
                                      title: units[index].title,
                                      isPremium: isPremiumUnit,
                                      isCurrent: isCurrent,
                                    ),
                                  );
                                },
                                childCount: units.length,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(child: 100.verticalSpace),
                      ],
                    ),
                  ),
                  // Top fade effect to soften the scrolling edge
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 25.h,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).scaffoldBackgroundColor,
                              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}

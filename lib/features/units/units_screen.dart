import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataProvider);
    final units = state.getUnitsByCourseId(courseId);
    if (units.isEmpty) {
      return const EmptyContentWidget(
        message: 'سيتم اضافة محاور  قريبا',
      );
    }
    return AppScaffold(
        paddingB: 0,
        paddingX: 0,
        swipeBackEnabled: true,
        appBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: const CustomAppBar(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SubscribeSection(),
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TayssirProgressWidget(
                name: state.getMaterialById(courseId).description,
                progress: state.getMaterialById(courseId).progress,
                upperText: state.getMaterialById(courseId).title,
                direction: state.getMaterialDirection(courseId),
              ),
            ),
            10.verticalSpace,
            Directionality(
              textDirection: state.getMaterialDirection(courseId),
              child: Expanded(
                child: ListView.builder(
                  itemCount: units.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final isCurrent =
                        state.isCurrentUnit(units[index].id, courseId);
                    final isPremiumUnit = state.isPremiumUnit(units[index].id);
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CustomLessonWidget(
                          onPressed: isPremiumUnit &&
                                  !ref
                                      .watch(userNotifierProvider)
                                      .requireValue!
                                      .isSub
                              ? () {
                                  DialogService.showNeedSubscriptionDialog(
                                      context);
                                }
                              : () {
                                  ref
                                          .read(currentUnitIdProvider.notifier)
                                          .state =
                                      int.parse(units[index].id.toString());
                                  context.pushNamed(
                                    AppRoutes.chapters.name,
                                    pathParameters: {
                                      'unitId': units[index].id.toString(),
                                    },
                                  );
                                },
                          imageUrl: units[index].image,
                          progress: units[index].progress,
                          title: units[index].title,
                          isPremium: isPremiumUnit,
                          isCurrent: isCurrent),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}

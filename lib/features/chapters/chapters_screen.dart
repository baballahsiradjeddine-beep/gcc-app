import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/core/custom_app_bar.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/chapters/widgets/custom_lesson_widget.dart';
import 'package:tayssir/features/home/presentation/subscribe_section.dart';
import 'package:tayssir/features/units/empty_content_widget.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/services/actions/dialog_service.dart';

import '../../providers/data/data_provider.dart';
import '../../providers/data/models/chapter_model.dart';
import '../exercice/presentation/state/exercice_controller.dart';
import '../units/widgets/unit_progress_widget.dart';

class ChaptersScreen extends HookConsumerWidget {
  const ChaptersScreen({super.key, required this.unitId});

  final int unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataProvider);
    final chapters = state.getChaptersByUnitId(unitId);
    const publicLessonKey = 'الدروس';

    if (chapters.isEmpty) {
      return const EmptyContentWidget(
        message: 'سيتم اضافة فصول  قريبا',
      );
    }

    Map<String, List<ChapterModel>> groupChapters(List<ChapterModel> chapters) {
      final Map<String, List<ChapterModel>> groupedChapters = {};
      int uniqueCounter = 0;

      for (final chapter in chapters) {
        if (chapter.description == null || chapter.description!.isEmpty) {
          final uniqueKey = 'unique_chapter_${uniqueCounter++}';
          groupedChapters[uniqueKey] = [chapter];
        } else {
          final description = chapter.description!;
          if (!groupedChapters.containsKey(description)) {
            groupedChapters[description] = [];
          }
          groupedChapters[description]!.add(chapter);
        }
      }

      return groupedChapters;
    }

    bool isUniqueChapter(String groupTitle) {
      return groupTitle.startsWith('unique_chapter_');
    }

    final groupedChapters = groupChapters(chapters);
    final tutorialKey = GlobalKey();

    useEffect(() {
      // handleStartigTutorial();
      return null;
    }, []);

    return AppScaffold(
        paddingB: 0,
        paddingX: 0,
        // paddingY: 0,
        swipeBackEnabled: true,
        topSafeArea: false,
        appBar: Padding(
          padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
          child: const CustomAppBar(),
        ),
        body: ShowCaseWidget(builder: (context) {
          // handleStartigTutorial(context);
          return Showcase(
            key: tutorialKey,
            description: 'هنا يمكنك مشاهدة الفصول الخاصة بك',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SubscribeSection(),
                20.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TayssirProgressWidget(
                    name:
                        ref.watch(dataProvider).getUnitById(unitId).description,
                    progress:
                        ref.watch(dataProvider).getUnitById(unitId).progress,
                    upperText:
                        ref.watch(dataProvider).getUnitById(unitId).title,
                    direction: ref.watch(dataProvider).getUnitDirection(unitId),
                  ),
                ),
                10.verticalSpace,
                Directionality(
                  textDirection:
                      ref.watch(dataProvider).getUnitDirection(unitId),
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: groupedChapters.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final groupTitle =
                            groupedChapters.keys.elementAt(index);
                        final chaptersInGroup = groupedChapters[groupTitle]!;

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 2.h,
                            horizontal: 20.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // groupTitle != publicLessonKey
                              isUniqueChapter(groupTitle)
                                  ? chapters.indexOf(chaptersInGroup.first) == 0
                                      ? const SizedBox(
                                          height: 15,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 2,
                                                  color: state.isLockedChapter(
                                                          unitId,
                                                          chaptersInGroup
                                                              .first.id,
                                                          ref
                                                              .watch(
                                                                  userNotifierProvider)
                                                              .requireValue!
                                                              .isSub)
                                                      ? const Color(
                                                          0xFFD3D3D3) // Grey if locked
                                                      : const Color(
                                                          0xffFF41AA), // Pink if unlocked
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 2,
                                              color: state.isLockedChapter(
                                                      unitId,
                                                      chaptersInGroup.first.id,
                                                      ref
                                                          .watch(
                                                              userNotifierProvider)
                                                          .requireValue!
                                                          .isSub)
                                                  ? const Color(
                                                      0xFFD3D3D3) // Grey if locked
                                                  : const Color(
                                                      0xffFF41AA), // Pink if unlocked
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            child: Text(
                                              groupTitle,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: state.isLockedChapter(
                                                            unitId,
                                                            chaptersInGroup
                                                                .first.id,
                                                            ref
                                                                .watch(
                                                                    userNotifierProvider)
                                                                .requireValue!
                                                                .isSub)
                                                        ? const Color(
                                                            0xFF909090)
                                                        : const Color(
                                                            0xff012246),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          Expanded(
                                            child: Container(
                                              height: 2,
                                              color: state.isLockedChapter(
                                                      unitId,
                                                      chaptersInGroup.first.id,
                                                      ref
                                                          .watch(
                                                              userNotifierProvider)
                                                          .requireValue!
                                                          .isSub)
                                                  ? const Color(
                                                      0xFFD3D3D3) // Grey if locked
                                                  : const Color(
                                                      0xffFF41AA), // Pink if unlocked
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              // 10.verticalSpace,
                              ...chaptersInGroup.map((chapter) {
                                // Create a unique key for each chapter
                                final GlobalKey showcaseKey = GlobalKey();
                                final isPro =
                                    state.isPremiumChapter(chapter.id);

                                return ShowCaseWidget(
                                  builder: (ctx) => Showcase(
                                    key: showcaseKey,
                                    description: chapter.title,
                                    child: CustomLessonWidget(
                                      onPressed: isPro &&
                                              !ref
                                                  .watch(userNotifierProvider)
                                                  .requireValue!
                                                  .isSub
                                          ? () {
                                              DialogService
                                                  .showNeedSubscriptionDialog(
                                                      context);
                                            }
                                          : state.isLockedChapter(
                                                  unitId,
                                                  chapter.id,
                                                  ref
                                                      .watch(
                                                          userNotifierProvider)
                                                      .requireValue!
                                                      .isSub)
                                              ? null
                                              : () {
                                                  // ShowCaseWidget.of(context)
                                                  //     .startShowCase([showcaseKey]);
                                                  // return;

                                                  AppLogger.sendLog(
                                                    email: ref
                                                        .watch(
                                                            userNotifierProvider)
                                                        .requireValue!
                                                        .email,
                                                    content:
                                                        'Opened chapter: ${chapter.title}',
                                                    type: LogType.chapters,
                                                  );
                                                  ref
                                                          .read(
                                                              currentChapterIdProvider
                                                                  .notifier)
                                                          .state =
                                                      int.parse(chapter.id
                                                          .toString());
                                                  //here im doing something realy bad and i need to review this , becayse i dont like push replacement and i want to use pop mechanism
                                                  context.pushReplacementNamed(
                                                    AppRoutes.exercices.name,
                                                  );
                                                },
                                      progress: chapter.progress,
                                      imageUrl: chapter.image,
                                      title: chapter.title,
                                      isCurrent: state.isCurrentCHapter(
                                          chapter.id,
                                          unitId,
                                          ref
                                              .watch(userNotifierProvider)
                                              .requireValue!
                                              .isSub),
                                      isPremium: isPro,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        }));
  }
}

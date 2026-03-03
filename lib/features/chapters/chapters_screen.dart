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
import 'package:tayssir/features/support_chat/presentation/tito_support_fab.dart';
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
    final user = ref.watch(userNotifierProvider).valueOrNull;
    final isSub = user?.isSub ?? false;
    final state = ref.watch(dataProvider);
    final chapters = state.getChaptersByUnitId(unitId);
    final unit = state.getUnitById(unitId);
    final material = state.getMaterialById(unit.materialId);

    const publicLessonKey = 'الدروس';

    if (chapters.isEmpty) {
      return const EmptyContentWidget(
        message: 'سيتم اضافة فصول  قريبا',
      );
    }
    
    // ... groupChapters and isUniqueChapter logic ...
    Map<String, List<ChapterModel>> groupChapters(List<ChapterModel> chapters) {
      final Map<String, List<ChapterModel>> groupedChapters = {};
      String? lastDescription;
      int groupCounter = 0;

      for (final chapter in chapters) {
        final currentDescription = (chapter.description == null || chapter.description!.isEmpty) 
            ? null 
            : chapter.description;
        
        // If the description changes (or becomes null/not null), start a new group
        if (currentDescription != lastDescription || groupedChapters.isEmpty) {
          final groupKey = currentDescription ?? 'default_group_${groupCounter++}';
          groupedChapters[groupKey] = [chapter];
          lastDescription = currentDescription;
        } else {
          // Add to the last group
          groupedChapters[groupedChapters.keys.last]!.add(chapter);
        }
      }

      return groupedChapters;
    }

    bool isUniqueChapter(String groupTitle) {
      return groupTitle.startsWith('default_group_');
    }

    final groupedChapters = groupChapters(chapters);
    final tutorialKey = GlobalKey();

    useEffect(() {
      // handleStartigTutorial();
      return null;
    }, []);

    final scrollOffset = useState<double>(0.0);

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
                            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 2.h),
                            child: TayssirProgressWidget(
                              name: unit.description,
                              progress: unit.progress,
                              upperText: unit.title,
                              direction: state.getUnitDirection(unitId),
                              startColor: _hexToColor(material.gradiantColorStart),
                              endColor: _hexToColor(material.gradiantColorEnd),
                              imageUrl: material.imageList,
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final groupTitle = groupedChapters.keys.elementAt(index);
                                final chaptersInGroup = groupedChapters[groupTitle]!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isUniqueChapter(groupTitle)
                                        ? index == 0
                                            ? const SizedBox(height: 0)
                                            : _buildDivider(state, unitId, chaptersInGroup.first.id, isSub)
                                        : _buildGroupHeader(context, state, unitId, chaptersInGroup.first.id, groupTitle, isSub),
                                    
                                    ...chaptersInGroup.map((chapter) {
                                      final isPro = state.isPremiumChapter(chapter.id);
                                      return CustomLessonWidget(
                                        onPressed: isPro && !isSub
                                            ? () => DialogService.showNeedSubscriptionDialog(context)
                                            : state.isLockedChapter(unitId, chapter.id, isSub)
                                                ? null
                                                : () {
                                                    if (user?.email != null) {
                                                      AppLogger.sendLog(
                                                        email: user!.email,
                                                        content: 'Opened chapter: ${chapter.title}',
                                                        type: LogType.chapters,
                                                      );
                                                    }
                                                    ref.read(currentChapterIdProvider.notifier).state = chapter.id;
                                                    context.pushReplacementNamed(AppRoutes.exercices.name);
                                                  },
                                        progress: chapter.progress,
                                        imageUrl: chapter.image,
                                        title: chapter.title,
                                        isCurrent: state.isCurrentCHapter(chapter.id, unitId, isSub),
                                        isPremium: isPro,
                                      );
                                    }),
                                  ],
                                );
                              },
                              childCount: groupedChapters.length,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(child: 100.verticalSpace),
                      ],
                    ),
                  ),
                  // Top fade effect that matches the current theme background
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

  Widget _buildDivider(dynamic state, int unitId, int chapterId, bool isSub) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: state.isLockedChapter(unitId, chapterId, isSub)
                        ? null
                        : const LinearGradient(
                            colors: [Colors.transparent, Color(0xffEC4899)],
                          ),
                    color: state.isLockedChapter(unitId, chapterId, isSub) 
                        ? (isDark ? const Color(0xFF334155) : const Color(0xFFD3D3D3)) 
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildGroupHeader(BuildContext context, dynamic state, int unitId, int chapterId, String groupTitle, bool isSub) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: _gradientLine(true)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              groupTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: state.isLockedChapter(unitId, chapterId, isSub)
                    ? const Color(0xFF909090)
                    : Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xff1E293B),
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'SomarSans',
              ),
            ),
          ),
          Expanded(child: _gradientLine(false)),
        ],
      ),
    );
  }

  Widget _gradientLine(bool reverse) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: reverse 
            ? [Colors.transparent, const Color(0xffEC4899).withOpacity(0.6)]
            : [const Color(0xffEC4899).withOpacity(0.6), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}

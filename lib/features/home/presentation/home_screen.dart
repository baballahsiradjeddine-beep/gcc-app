
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/home/presentation/subscribe_section.dart';
import 'package:tayssir/features/home/presentation/view_style.dart';
import 'package:tayssir/providers/data/models/material_model.dart';
import 'package:tayssir/utils/extensions/strings.dart';

import '../../../providers/data/data_provider.dart';
import '../../../common/core/app_scaffold.dart';
import '../../../router/app_router.dart';
import '../../../providers/user/user_notifier.dart';
import '../../../common/core/custom_app_bar.dart';
import 'widgets/course_widget.dart';
import 'widgets/courses_grid_view.dart';
import 'widgets/courses_list_view.dart';
import 'widgets/home_header.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewStyle = useState<ViewStyle>(ViewStyle.list);
    final courses = ref.watch(dataProvider).contentData.modules;
    // final homeGlobalKey =
    //     useMemoized(() => GlobalKey()); // Use useMemoized for stable key

    // // Start showcase after first build
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        // Intro.of(context).start();
      });
      return null;
    }, const []);

    // final courses = <Module>[];
    return AppScaffold(
      topSafeArea: true,
      appBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: const CustomAppBar(),
      ),
      isScroll: true,
      paddingX: 0,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(dataProvider.notifier).refreshData();
        },
        child: Column(
          children: [
            const SubscribeSection(),

            // UserProgressWidget(courses: courses),
            10.verticalSpace,
            //if debug
            if (AppConsts.isDebug) ...[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // ref.read(dataServiceProvider).fetchCourses();
                          // inspect(ref.watch(tokenProvider));
                        },
                        icon: const Icon(Icons.bug_report, size: 18),
                        label: const Text('Debug State'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref.invalidate(dataProvider);
                          ref.read(dataProvider.notifier).getData();
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Refresh'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            15.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: HomeHeader(viewStyle: viewStyle),
            ),
            15.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: courses.isEmpty
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        children: List.generate(
                          5,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 0.w),
                            height: 110.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: 16.h,
                                          width: 150.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          height: 12.h,
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          height: 28.h,
                                          width: 90.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      key: key,
                      child: viewStyle.value == ViewStyle.list
                          ? HomeListView<MaterialModel>(
                              items: courses,
                              itemBuilder: (course) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 10),
                                    child: CardWidget(
                                      title: course.title,
                                      subTitle: course.description ?? '',
                                    
                                      onPressed: () {
                                        AppLogger.sendLog(
                                            email: ref
                                                .watch(userNotifierProvider)
                                                .requireValue!
                                                .email,
                                            content:
                                                "User clicked on course: ${course.title} (ID: ${course.id}) ",
                                            type: LogType.home);
                                        context.pushNamed(AppRoutes.units.name,
                                            pathParameters: {
                                              'courseId': course.id.toString(),
                                            });
                                      },
                                      imageList: course.imageList,
                                      imageGrid: course.imageGrid,
                                      startColor: Color(
                                          course.gradiantColorStart.toHexColor),
                                      endColor: Color(
                                        course.gradiantColorEnd.toHexColor,
                                      ),
                                    ),
                                  ))
                          : HomeGridView<MaterialModel>(
                              items: courses,
                              itemBuilder: (course) => CardWidget(
                                title: course.title,
                                subTitle: course.description ?? '',
                                onPressed: () {
                                  AppLogger.sendLog(
                                      email: ref
                                          .watch(userNotifierProvider)
                                          .requireValue!
                                          .email,
                                      content:
                                          "User clicked on course: ${course.title} (ID: ${course.id})",
                                      type: LogType.home);

                                  context.pushNamed(AppRoutes.units.name,
                                      pathParameters: {
                                        'courseId': course.id.toString(),
                                      });
                                },
                                imageGrid: course.imageGrid,
                                imageList: course.imageList,
                                startColor:
                                    Color(course.gradiantColorStart.toHexColor),
                                endColor: Color(
                                  course.gradiantColorEnd.toHexColor,
                                ),
                                isGrid: true,
                              ),
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

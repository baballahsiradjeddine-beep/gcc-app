import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/home/presentation/subscribe_section.dart';
import 'package:tayssir/features/home/presentation/view_style.dart';

import 'package:tayssir/features/tools/common/models/tool_model.dart';
import 'package:tayssir/features/tools/common/state/tools_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';

import '../../../common/core/app_scaffold.dart';
import '../../../common/core/custom_app_bar.dart';

import '../home/presentation/widgets/course_widget.dart';
import '../home/presentation/widgets/courses_grid_view.dart';
import '../home/presentation/widgets/courses_list_view.dart';
import '../home/presentation/widgets/home_header.dart';

class ToolsScreen extends HookConsumerWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewStyle = useState<ViewStyle>(ViewStyle.list);
    final tools = ref.watch(toolsProvider);
    return AppScaffold(
      topSafeArea: true,
      extendBody: true,
      bodyBackgroundColor: Colors.transparent,
      paddingX: 0,
      paddingB: 0,
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(toolsProvider),
        color: const Color(0xFF00B4D8),
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: const CustomAppBar(),
              ),
            ),

            // Hero Banner Section
            SliverToBoxAdapter(
              child: SubscribeSection(),
            ),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: HomeHeader(title: 'الأدوات المتاحة', viewStyle: viewStyle),
              ),
            ),

            // Tools Content
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
              sliver: viewStyle.value == ViewStyle.list
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: CardWidget(
                            title: tools[index].name,
                            subTitle: tools[index].description,
                            onPressed: () {
                              final userEmail = ref.read(userNotifierProvider).valueOrNull?.email;
                              if (userEmail != null) {
                                AppLogger.sendLog(
                                  email: userEmail,
                                  content: 'Opened tool: ${tools[index].name}',
                                  type: LogType.tools,
                                );
                              }
                              context.pushNamed(tools[index].pathName);
                            },
                            startColor: tools[index].startColor,
                            toolImage: tools[index].toolImage,
                            endColor: tools[index].endColor,
                            isLocked: tools[index].isLocked,
                            isStartBottomColor: tools[index].isStartBottomColor,
                          ),
                        ),
                        childCount: tools.length,
                      ),
                    )
                  : SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.h,
                        crossAxisSpacing: 16.w,
                        childAspectRatio: 1.1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => CardWidget(
                          title: tools[index].name,
                          subTitle: tools[index].description,
                          onPressed: () {
                            final userEmail = ref.read(userNotifierProvider).valueOrNull?.email;
                            if (userEmail != null) {
                              AppLogger.sendLog(
                                email: userEmail,
                                content: 'Opened tool: ${tools[index].name}',
                                type: LogType.tools,
                              );
                            }
                            context.pushNamed(tools[index].pathName);
                          },
                          startColor: tools[index].startColor,
                          endColor: tools[index].endColor,
                          isGrid: true,
                          isStartBottomColor: tools[index].isStartBottomColor,
                          toolImage: tools[index].toolImage,
                          isLocked: tools[index].isLocked,
                        ),
                        childCount: tools.length,
                      ),
                    ),
            ),

            SliverToBoxAdapter(child: 120.verticalSpace),
          ],
        ),
      ),
    );
  }
}

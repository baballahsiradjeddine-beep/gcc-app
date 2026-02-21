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

import '../home/presentation/home_screen.dart';
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
      appBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: const CustomAppBar(),
      ),
      isScroll: true,
      paddingX: 0,
      topSafeArea: true,
      body: Column(
        children: [
          const SubscribeSection(),
          15.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: HomeHeader(title: 'الأدوات المتاحة', viewStyle: viewStyle),
          ),
          15.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: viewStyle.value == ViewStyle.list
                ? HomeListView<ToolModel>(
                    items: tools,
                    itemBuilder: (tool) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          child: CardWidget(
                            title: tool.name,
                            subTitle: tool.description,
                            onPressed: () {
                              AppLogger.sendLog(
                                email: ref
                                    .watch(userNotifierProvider)
                                    .requireValue!
                                    .email,
                                content: 'Opened tool: ${tool.name}',
                                type: LogType.tools,
                              );
                              context.pushNamed(tool.pathName);
                            },
                            startColor: tool.startColor,
                            toolImage: tool.toolImage,
                            endColor: tool.endColor,
                            isLocked: tool.isLocked,
                            isStartBottomColor: tool.isStartBottomColor,
                          ),
                        ))
                : HomeGridView<ToolModel>(
                    items: tools,
                    itemBuilder: (tool) => CardWidget(
                      title: tool.name,
                      subTitle: tool.description,
                      onPressed: () {
                        AppLogger.sendLog(
                          email: ref
                              .watch(userNotifierProvider)
                              .requireValue!
                              .email,
                          content: 'Opened tool: ${tool.name}',
                          type: LogType.tools,
                        );
                        context.pushNamed(tool.pathName);
                      },
                      startColor: tool.startColor,
                      endColor: tool.endColor,
                      isGrid: true,
                      isStartBottomColor: tool.isStartBottomColor,
                      toolImage: tool.toolImage,
                      isLocked: tool.isLocked,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

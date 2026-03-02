import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/home/presentation/view_style.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/resources.dart';

class ChangeViewWidget extends ConsumerWidget {
  const ChangeViewWidget({
    super.key,
    required this.viewStyle,
  });

  final ValueNotifier<ViewStyle> viewStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final email = ref.watch(userNotifierProvider).valueOrNull?.email;
        if (email != null) {
          AppLogger.sendLog(
            email: email,
            content:
                'Change view style to ${viewStyle.value == ViewStyle.list ? 'grid' : 'list'}',
            type: LogType.home,
          );
        }
        viewStyle.value =
            viewStyle.value == ViewStyle.list ? ViewStyle.grid : ViewStyle.list;
      },
      child: SvgPicture.asset(
        !(viewStyle.value == ViewStyle.list) ? SVGs.list : SVGs.grid,
      ),
    );
  }
}

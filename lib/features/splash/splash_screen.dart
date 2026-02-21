import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/utils/extensions/context.dart';

import '../../common/core/app_logo.dart';
import '../../resources/resources.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = context.isSmallDevice ? 220.h : 250.h;

    return SafeArea(
      top: false,
      child: Scaffold(
          body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Image.asset(
            //   Images.tito,
            // ),
            SizedBox(
              height: 1.h,
            ),
            Column(
              children: [
                SvgPicture.asset(
                  SVGs.titoLogin,
                  height: size,
                ),
                20.verticalSpace,
                const AppLogo(),
              ],
            ),
            // const Spacer(),
            Column(
              children: [
                const TayssirDataLoader(),
                20.verticalSpace,
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class TayssirDataLoader extends StatelessWidget {
  const TayssirDataLoader({
    super.key,
    this.textSize = 20,
    this.iconSize = 50,
  });

  final double textSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'جاري تحميل البيانات',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.textBlack,
              fontSize: textSize.sp,
              fontWeight: FontWeight.bold),
        ),
        10.verticalSpace,
        LoadingAnimationWidget.progressiveDots(
            size: iconSize, color: AppColors.secondaryColor),
      ],
    );
  }
}

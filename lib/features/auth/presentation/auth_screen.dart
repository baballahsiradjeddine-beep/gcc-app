import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_logo.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/utils/enums/triangle_side.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/utils/extensions/context.dart';

import '../../../common/tito_bubble_talk_widget.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
        paddingB: 0.r,
        isScroll: false,
        topSafeArea: false,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    50.verticalSpace,
                    const AppLogo(),
                    20.verticalSpace,
                    const TitoBubbleTalkWidget(
                      text: AppStrings.heyImTito,
                      triangleSide: TriangleSide.bottom,
                    ),
                    Container(
                      color: Colors.transparent,
                      child: SvgPicture.asset(
                        SVGs.titoBoarding,
                        height: context.isSmallDevice ? 120.h : 150.h,
                      ),
                    ),
                    20.verticalSpace,
                    Text(
                      AppStrings.welcome,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.isSmallDevice ? 15.sp : 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    20.verticalSpace,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BigButton(
                            buttonType: ButtonType.primary,
                            text: AppStrings.startNow,
                            onPressed: () {
                              context.goNamed(AppRoutes.register.name);
                            },
                          ),
                          10.verticalSpace,
                          BigButton(
                              buttonType: ButtonType.secondary,
                              text: AppStrings.iHaveAccount,
                              onPressed: () {
                                context.goNamed(AppRoutes.login.name);
                              }),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                  ],
                )),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/utils/extensions/context.dart';

import '../resources/resources.dart';


class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.isSmallDevice ? 170.h : 200.h;
    return AppScaffold(
        body: SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            SVGs.comingSoon,
            height: size,
            //
          ),
          Text(
            AppStrings.comingSoon,
            style: TextStyle(
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff6F6F6F)),
          ),
        ],
      ),
    ));
  }
}

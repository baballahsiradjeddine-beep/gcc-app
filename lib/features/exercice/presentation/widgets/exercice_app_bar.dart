import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/features/exercice/presentation/state/exercise_state.dart';
import 'package:tayssir/features/exercice/presentation/widgets/exercise_header.dart';
import 'package:tayssir/resources/resources.dart';

import '../../../../resources/colors/app_colors.dart';
import '../../../../router/app_router.dart';
import '../../../../services/actions/bottom_sheet_service.dart';
import '../../../../utils/extensions/go_router_extensions.dart';

class ExerciceAppBar extends StatelessWidget {
  const ExerciceAppBar({
    super.key,
    required this.exercisesState,
    required this.onClosePressed,
  });

  final ExerciseState exercisesState;
  final VoidCallback onClosePressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
            onTap: onClosePressed,
            child: const Icon(
              Icons.close,
              color: Color(0xffBABABA),
            )),
        4.horizontalSpace,
        ExerciseHeader(progress: exercisesState.progress),
        10.horizontalSpace,
        SvgPicture.asset(
          SVGs.icGem,
          height: 20.h,
        ),
        4.horizontalSpace,
        Text(
          exercisesState.points.toString(),
          style: TextStyle(
            color: AppColors.darkColor,
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

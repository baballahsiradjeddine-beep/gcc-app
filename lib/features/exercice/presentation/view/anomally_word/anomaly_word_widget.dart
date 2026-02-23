import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/features/exercice/presentation/view/select_right_option/latext_text_widget.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class AnomalyWordWidget extends ConsumerWidget {
  const AnomalyWordWidget({
    super.key,
    required this.word,
    required this.isSelected,
    required this.onTap,
    required this.isCorrectWord,
    required this.fontSize,
  });

  final LatexField<String> word;
  final bool isSelected;
  final Function onTap;
  final bool isCorrectWord;
  final double fontSize;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShowResult = ref.watch(exercicesProvider).isShowResult;

    Color getBorderColor() {
      if (isShowResult) {
        if (isSelected && isCorrectWord) {
          return Colors.green;
        } else if (isSelected) {
          return Colors.red;
        }
        return AppColors.greyColor;
      } else {
        if (isSelected) {
          return AppColors.primaryColor;
        }
        return AppColors.greyColor;
      }
    }

    // text color
    Color getTextColor() {
      if (isShowResult) {
        if (isCorrectWord && isSelected) {
          return Colors.green;
        } else if (isSelected) {
          return Colors.red;
        }
        return Colors.black;
      } else {
        if (isSelected) {
          return AppColors.primaryColor;
        }

        return Colors.black;
      }
    }

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: getBorderColor(),
              width: 1.5,
            ),
          ),
          // child: Text(
          //   word.text,
          //   style: TextStyle(
          //     color: getTextColor(),
          //     fontSize: 20,
          //   ),
          // ),
          child: LatextTextWidget(
            text: word.cleanText,
            isLatex: word.isLatex,
            useFittedBox: true,
            textStyle: TextStyle(
              color: getTextColor(),
              fontSize: fontSize,
            ),
          )),
    );
  }
}

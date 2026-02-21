import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/exercice/presentation/view/link_word/pair_two_words_provider.dart';
import 'package:tayssir/features/exercice/presentation/view/link_word/pair_two_words_state.dart';
import 'package:tayssir/features/exercice/presentation/view/select_right_option/latext_text_widget.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class WordWidget extends StatelessWidget {
  const WordWidget({
    super.key,
    required this.onWordPressed,
    required this.word,
    required this.state,
    required this.index,
    required this.isFirst,
  });

  final Function(int index) onWordPressed;
  final LatexField<String> word;
  final PairTwoWordsState state;
  final int index;
  final bool isFirst;

  Color _getColorByStatus() {
    final status =
        isFirst ? state.getFirstStatus(index) : state.getSecondStatus(index);
    switch (status) {
      case PairTwoWordsStatus.done:
        return AppColors.greyColor;
      case PairTwoWordsStatus.correct:
        return AppColors.greenColor;
      case PairTwoWordsStatus.wrong:
        return AppColors.redColor;
      case PairTwoWordsStatus.selected:
        return AppColors.primaryColor;
      case PairTwoWordsStatus.unselected:
        return AppColors.greyColor;
      default:
        return AppColors.greyColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = _getColorByStatus();
    final status =
        isFirst ? state.getFirstStatus(index) : state.getSecondStatus(index);
    final bool isSelected = status == PairTwoWordsStatus.selected;

    return GestureDetector(
      onTap: () => onWordPressed(index),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height:
            // word.is
            // if word.length > 20
            word.text.length > 20 ? 80.h : 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: borderColor, width: 2),
            left: BorderSide(color: borderColor, width: 2),
            right: BorderSide(color: borderColor, width: 2),
            bottom: BorderSide(color: borderColor, width: 4),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        // child: Text(
        //   word.text,
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     color: status == PairTwoWordsStatus.done
        //         ? AppColors.greyColor
        //         : borderColor,
        //     fontSize: 13.sp,
        //     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        //   ),
        // ),
        child: LatextTextWidget(
          text: word.cleanText,
          isLatex: word.isLatex,
          useFittedBox: false,
          textStyle: TextStyle(
            color: status == PairTwoWordsStatus.done
                ? AppColors.greyColor
                : status == PairTwoWordsStatus.correct
                    ? AppColors.greenColor
                    : status == PairTwoWordsStatus.wrong
                        ? AppColors.redColor
                        : status == PairTwoWordsStatus.selected
                            ? AppColors.primaryColor
                            : Colors.black,
            fontSize: word.text.length > 20 ? 11.sp : 12.sp,
            fontWeight: (isSelected ||
                    status == PairTwoWordsStatus.correct ||
                    status == PairTwoWordsStatus.wrong)
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

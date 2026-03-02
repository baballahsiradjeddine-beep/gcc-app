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

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final status = isFirst ? state.getFirstStatus(index) : state.getSecondStatus(index);
    
    final bool isSelected = status == PairTwoWordsStatus.selected;
    final bool isCorrect = status == PairTwoWordsStatus.correct;
    final bool isWrong = status == PairTwoWordsStatus.wrong;
    final bool isDone = status == PairTwoWordsStatus.done;
    
    final Color color = isCorrect 
        ? const Color(0xFF10B981) 
        : (isWrong ? const Color(0xFFF43F5E) : AppColors.primaryColor);

    return GestureDetector(
      onTap: isDone ? null : () => onWordPressed(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 80.h),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withOpacity(isDark ? 0.1 : 0.05)
              : isCorrect
                  ? const Color(0xFF10B981).withOpacity(0.1)
                  : isWrong
                      ? const Color(0xFFF43F5E).withOpacity(0.1)
                      : isDone
                          ? (isDark ? const Color(0xFF334155).withOpacity(0.3) : const Color(0xFFF1F5F9))
                          : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected 
                ? color 
                : isCorrect
                    ? const Color(0xFF10B981)
                    : isWrong
                        ? const Color(0xFFF43F5E)
                        : isDone
                            ? (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))
                            : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: (isSelected || isCorrect || isWrong) ? 2.5 : 1,
          ),
          boxShadow: (isSelected || isCorrect || isWrong) 
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        transform: isSelected ? (Matrix4.identity()..scale(1.03)) : (isDone ? (Matrix4.identity()..scale(0.95)) : Matrix4.identity()),
        child: Opacity(
          opacity: isDone ? 0.5 : 1.0,
          child: LatextTextWidget(
            text: word.cleanText,
            isLatex: word.isLatex,
            useFittedBox: true,
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: isSelected 
                  ? (isDark ? AppColors.primaryColor : const Color(0xFF0077B6))
                  : isCorrect
                      ? const Color(0xFF10B981)
                      : isWrong
                          ? const Color(0xFFF43F5E)
                          : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
              fontSize: 13.sp,
              fontWeight: (isSelected || isCorrect || isWrong) ? FontWeight.w900 : FontWeight.bold,
              fontFamily: 'SomarSans',
            ),
          ),
        ),
      ),
    );
  }
}

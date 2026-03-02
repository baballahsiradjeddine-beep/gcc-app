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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color getBorderColor() {
      if (isShowResult) {
        if (isSelected && isCorrectWord) return const Color(0xFF10B981);
        if (isSelected) return const Color(0xFFF43F5E);
        return isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
      }
      return isSelected ? AppColors.primaryColor : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
    }

    return GestureDetector(
      onTap: () => onTap(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.all(6.r),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected 
              ? null 
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(99.r), // Standard Pill
          border: Border.all(
            color: getBorderColor(),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected 
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
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
        transform: isSelected ? (Matrix4.identity()..scale(1.08)) : Matrix4.identity(),
        child: LatextTextWidget(
          text: word.cleanText,
          isLatex: word.isLatex,
          useFittedBox: true,
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            color: isSelected 
                ? Colors.white 
                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
            fontFamily: 'SomarSans',
          ),
        ),
      ),
    );
  }
}

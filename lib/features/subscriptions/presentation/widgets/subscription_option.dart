// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/push_buttons/pushable_button.dart';
import 'package:tayssir/features/subscriptions/presentation/widgets/stroke_text.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class SubscriptionOptionWidget extends StatelessWidget {
  final int totalPrice;
  final int? discountedPrice;
  final double? percentageDiscount;
  final String descriptionText;
  final double priceFontSize;
  final List<Color> gradientColors;
  final Color priceColor;
  final Color strokeColor;
  final double strokeWidth;
  final Color descriptionColor;
  final double descriptionFontSize;
  final FontWeight descriptionFontWeight;
  final Color innerColor;
  final bool isSelected;
  final VoidCallback? onPressed;
  final Color? disabledColor;

  const SubscriptionOptionWidget({
    super.key,
    this.totalPrice = 2500,
    this.discountedPrice,
    this.percentageDiscount,
    this.descriptionText =
        'بينما غيرنا يفرض عليك أسعارًا مرتفعة مقابل محتوى محدود!',
    this.priceFontSize = 24,
    this.gradientColors = const [Color(0XFF175DC7), Color(0XFF00C4F6)],
    this.priceColor = AppColors.primaryColor,
    this.innerColor = const Color(0XFF175DC7),
    this.strokeColor = Colors.white,
    this.strokeWidth = 2,
    this.isSelected = true,
    this.onPressed,
    this.disabledColor,
    this.descriptionColor = Colors.white,
    this.descriptionFontSize = 14,
    this.descriptionFontWeight = FontWeight.bold,
  });

  bool get hasDiscount => discountedPrice != null || percentageDiscount != null;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: isSelected
              ? LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : (isDark ? const Color(0xFF1E293B) : Colors.white),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? gradientColors.first.withOpacity(0.3) 
                  : (isDark ? Colors.black26 : Colors.black.withOpacity(0.04)),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isSelected 
                ? Colors.white.withOpacity(0.2) 
                : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02)),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            children: [
              if (isSelected)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.1,
                    child: CustomPaint(
                      painter: _DotPatternPainter(),
                    ),
                  ),
                ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPriceSection(),
                    12.verticalSpace,
                    Text(
                      descriptionText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white.withOpacity(0.9) : (isDark ? Colors.white70 : const Color(0xFF64748B)),
                        fontSize: descriptionFontSize.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SomarSans',
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasDiscount && isSelected)
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: _buildDiscountBadge(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    if (hasDiscount) {
      return Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final lineWidth =
                  (constraints.maxWidth * 0.55).clamp(60.0, 140.0);
              return Stack(
                alignment: Alignment.center,
                children: [
                  StrokeText(
                    text: '${totalPrice.toStringAsFixed(0)} دج',
                    fontSize: (priceFontSize * 0.6).sp,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? priceColor.withOpacity(0.6)
                        : AppColors.disabledTextColor,
                    strokeColor: isSelected
                        ? strokeColor.withOpacity(0.6)
                        : AppColors.disabledTextColor,
                    strokeWidth: strokeWidth * 0.7,
                  ),
                  // Diagonal Strike Line (responsive)
                  Transform.rotate(
                    angle: -0.18,
                    child: Container(
                      height: 2.5,
                      width: lineWidth,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isSelected
                              ? [Colors.red.shade400, Colors.red.shade600]
                              : [
                                  AppColors.disabledTextColor,
                                  AppColors.disabledTextColor
                                ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          4.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StrokeText(
                text: 'فقط',
                fontSize: (priceFontSize * 0.5).sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? priceColor : AppColors.disabledTextColor,
                strokeColor:
                    isSelected ? strokeColor : AppColors.disabledTextColor,
                strokeWidth: strokeWidth * 0.8,
              ),
              4.horizontalSpace,
              StrokeText(
                text:
                    '${discountedPrice?.toStringAsFixed(0) ?? (totalPrice * (1 - (percentageDiscount ?? 0) / 100)).toStringAsFixed(0)} دج',
                fontSize: (priceFontSize * 1.2).sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? priceColor : AppColors.disabledTextColor,
                strokeColor:
                    isSelected ? strokeColor : AppColors.disabledTextColor,
                strokeWidth: strokeWidth,
              ),
            ],
          ),
        ],
      );
    }

    return StrokeText(
      text: '${totalPrice.toStringAsFixed(0)} دج فقط',
      fontSize: priceFontSize.sp,
      fontWeight: FontWeight.bold,
      color: isSelected ? priceColor : AppColors.disabledTextColor,
      strokeColor: isSelected ? strokeColor : AppColors.disabledTextColor,
      strokeWidth: strokeWidth,
    );
  }

  Widget _buildDiscountBadge() {
    final discount = percentageDiscount ??
        ((totalPrice - (discountedPrice ?? totalPrice)) / totalPrice * 100);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade400,
            Colors.orange.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: 16.sp,
          ),
          4.horizontalSpace,
          Text(
            '${discount.toStringAsFixed(0)}%-',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2);

    const double spacing = 12.0;

    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

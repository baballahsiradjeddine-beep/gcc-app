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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PushableButton(
            height: discountedPrice != null || percentageDiscount != null
                ? 140.h
                : 100.h,
            allowDisabledClick: true,
            elevation: 7,
            onPressed: !isSelected ? onPressed : null,
            hslColor: HSLColor.fromColor(innerColor),
            hasBorder: false,
            borderRadius: 16,
            hslDisabledColor: HSLColor.fromColor(disabledColor ?? innerColor),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: gradientColors,
                      )
                    : null,
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildPriceSection(),
                  10.verticalSpace,
                  SizedBox(
                    width: 0.6.sw,
                    child: Text(
                      descriptionText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            isSelected ? descriptionColor : AppColors.textBlack,
                        fontSize: descriptionFontSize,
                        fontWeight: descriptionFontWeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Discount Badge
          if (hasDiscount && isSelected)
            Positioned(
              top: -8,
              left: 16,
              child: _buildDiscountBadge(),
            ),
        ],
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

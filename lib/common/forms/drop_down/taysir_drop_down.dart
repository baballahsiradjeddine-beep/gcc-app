import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/providers/user/wilaya_dropdown_item.dart';
import '../../../resources/colors/app_colors.dart';

class TayssirDropDown<T extends TaysirDropdownItem> extends StatelessWidget {
  const TayssirDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    required this.hintText,
    this.validator,
    required this.iconPath,
  });

  final List<T> items;
  final ValueChanged<T?> onChanged;
  final T? selectedItem;
  final String iconPath;
  final String hintText;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buildButtonContent(String text, {bool isHint = false}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 20.sp,
            colorFilter: ColorFilter.mode(
              AppColors.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          Text(text,
              style: TextStyle(
                color: isHint 
                    ? Colors.blueGrey.shade400 
                    : (isDark ? Colors.white : AppColors.textBlack),
                fontSize: 15.sp,
                fontWeight: isHint ? FontWeight.w500 : FontWeight.bold,
                fontFamily: 'SomarSans',
              )),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8.w, bottom: 8.h),
          child: Text(
            hintText,
            style: TextStyle(
              color: isDark ? Colors.blueGrey.shade300 : AppColors.textBlack,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'SomarSans',
            ),
          ),
        ),
        DropdownButtonFormField2<T>(
          isExpanded: true,
          dropdownStyleData: DropdownStyleData(
            elevation: 8,
            maxHeight: 250.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.secondaryDark : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          hint: buildButtonContent(hintText, isHint: true),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              key: Key(item.number.toString()),
              child: Text(
                item.name,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textBlack,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SomarSans',
                ),
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return items.map((T item) {
              return buildButtonContent(item.name);
            }).toList();
          },
          validator: validator ?? (value) => value == null ? 'الرجاء الاختيار' : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? AppColors.secondaryDark : Colors.blueGrey.shade50,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(
                color: isDark ? Colors.blueGrey.shade800 : Colors.blueGrey.shade200,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(
                color: isDark ? Colors.blueGrey.shade800 : Colors.blueGrey.shade200,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
          ),
          value: selectedItem,
          onChanged: onChanged,
          menuItemStyleData: MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
        ),
      ],
    );
  }
}

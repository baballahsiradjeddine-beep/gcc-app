import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/features/tools/grade_calc/speciality_model.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'custom_drop_down_item_widget.dart';

class SpecialityDropDown extends StatelessWidget {
  final List<SpecialityModel> items;
  final void Function(SpecialityModel?) onChanged;
  final SpecialityModel? selectedItem;
  const SpecialityDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    required this.hintText,
    this.validator,
  });

  final String hintText;
  final String? Function(SpecialityModel?)? validator;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buildButtonContent(String text, String? iconPath) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (iconPath != null)
            SvgPicture.asset(
              iconPath,
              width: 24.w,
            ),
          Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textBlack,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'SomarSans',
            ),
          ),
        ],
      );
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: DropdownButtonFormField2<SpecialityModel>(
        isExpanded: true,
        dropdownStyleData: buildMenuStyle(isDark),
        hint: buildButtonContent(hintText, null),
        items: items.map((SpecialityModel speciality) {
          return DropdownMenuItem<SpecialityModel>(
            value: speciality,
            alignment: Alignment.center,
            child: CustomDropDownItemWidget(
              itemName: speciality.name,
              iconPath: speciality.iconPath,
            ),
          );
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return items.map((SpecialityModel speciality) {
            return buildButtonContent(speciality.name, speciality.iconPath);
          }).toList();
        },
        validator: validator ?? (value) {
          if (value == null) {
            return 'الرجاء اختيار التخصص';
          }
          return null;
        },
        decoration: buildInputDecoration(isDark),
        buttonStyleData: const ButtonStyleData(
          elevation: 0,
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? Colors.white38 : AppColors.greyColor,
          ),
        ),
        alignment: Alignment.centerRight,
        value: selectedItem,
        onChanged: onChanged,
      ),
    );
  }

  InputBorder buildBorder(bool isDark, {Color? color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color ?? (isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFE2E8F0)),
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(20.r),
    );
  }

  InputDecoration buildInputDecoration(bool isDark) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      filled: true,
      fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      border: buildBorder(isDark),
      enabledBorder: buildBorder(isDark),
      focusedBorder: buildBorder(isDark, color: AppColors.primaryColor),
      errorBorder: buildBorder(isDark, color: Colors.red),
      focusedErrorBorder: buildBorder(isDark),
    );
  }

  DropdownStyleData buildMenuStyle(bool isDark) {
    return DropdownStyleData(
      isOverButton: false,
      maxHeight: 250.h,
      width: 320.w,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );
  }
}

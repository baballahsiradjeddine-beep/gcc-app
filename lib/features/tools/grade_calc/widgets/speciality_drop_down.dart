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
  // final Widget icon;
  const SpecialityDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    required this.hintText,
    this.validator,
    // required this.icon ,
  });

  final String hintText;
  final String? Function(SpecialityModel?)? validator;

  @override
  Widget build(BuildContext context) {
    Widget buildButtonContent(
      String text,
    ) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon(icon, color: AppColors.primaryColor),
          SvgPicture.asset(
            selectedItem!.iconPath,
            width: 20.w,
          ),
          Text(text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              )),
        ],
      );
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: DropdownButtonFormField2<SpecialityModel>(
        isExpanded: true,
        dropdownStyleData: buildMenuStyle(),
        hint: buildButtonContent(hintText),
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
            return buildButtonContent(speciality.name);
          }).toList();
        },
        validator: (value) {
          if (value == null) {
            return 'الرجاء اختيار التخصص';
          }
          return null;
        },
        decoration: buildInputDecoration(),
        buttonStyleData: const ButtonStyleData(
          elevation: 5,
        ),
        alignment: Alignment.centerRight,
        value: selectedItem,
        onChanged: onChanged,
      ),
    );
  }

  InputBorder buildBorder({
    color = AppColors.borderColor,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 1.5,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(
        left: 0,
        right: 10,
      ),
      border: buildBorder(),
      enabledBorder: buildBorder(),
      focusedBorder: buildBorder(),
      errorBorder: buildBorder(
        color: Colors.red,
      ),
      focusedErrorBorder: buildBorder(),
    );
  }

  DropdownStyleData buildMenuStyle() {
    return DropdownStyleData(
      isOverButton: false,
      maxHeight: 120.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

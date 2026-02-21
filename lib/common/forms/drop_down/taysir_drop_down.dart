import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/common/forms/drop_down/custom_drop_down_item_widget.dart';
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
    Widget buildButtonContent(
      String text,
    ) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon(icon, color: AppColors.primaryColor),
          SvgPicture.asset(
            iconPath,
            width: 20.w,
            colorFilter: const ColorFilter.mode(
              AppColors.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          Text(text,
              style: TextStyle(
                color: const Color(0xff012246),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              )),
        ],
      );
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: DropdownButtonFormField2<T>(
        isExpanded: true,
        dropdownStyleData: buildMenuStyle(),
        hint: buildButtonContent(hintText),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            key: Key(item.number.toString()),
            alignment: Alignment.center,
            child: CustomDropDownItemWidget(
              itemName: item.name,
              itemNumber: item.number,
            ),
          );
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return items.map((T wilaya) {
            return buildButtonContent(wilaya.name);
          }).toList();
        },
        validator: (value) {
          if (value == null) {
            return 'الرجاء اختيار الولاية';
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
            color: AppColors.borderColor,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

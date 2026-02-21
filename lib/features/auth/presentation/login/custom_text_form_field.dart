import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

import '../../../../utils/validators.dart';

class CustomTextFormField extends HookConsumerWidget {
  final TextEditingController? controller;

  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? checkerFunc;
  final bool isReadOnly;
  final bool isMultiLine;
  final String? initialValue;

  const CustomTextFormField(
      {super.key,
      this.controller,
      this.hintText = "",
      required this.labelText,
      this.validator = Validators.nonEmptyValidator,
      this.isPassword = false,
      this.suffix,
      this.prefix,
      this.keyboardType,
      this.textInputAction,
      this.isReadOnly = false,
      this.checkerFunc,
      this.isMultiLine = false,
      this.initialValue})
      : assert(
          initialValue == null || controller == null,
          "initialValue and controller need to be differntly null",
        );

  border([double? width]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(
        style: BorderStyle.solid,
        width: 1.5,
        color: AppColors.borderColor,
      ),
    );
  }

  focusedborder([double? width]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        width: width ?? 2,
        color: const Color(0xffBEE0FF),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHidden = useState<bool>(true);
    final focusNode = useFocusNode();
    final isFocused = useState<bool>(false);
    useEffect(() {
      focusNode.addListener(() {
        isFocused.value = focusNode.hasFocus;
      });
      return null;
    }, [focusNode]);

    TextDirection getDirection(String text) {
      final isRTL = RegExp(r'^[\u0600-\u06FF]').hasMatch(text);
      return isRTL ? TextDirection.rtl : TextDirection.ltr;
    }

//TODO:
    return TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        initialValue: initialValue,
        textDirection: getDirection(controller!.value.text),
        keyboardType: keyboardType,
        textInputAction: textInputAction ?? TextInputAction.next,
        maxLines: isMultiLine ? 5 : 1,
        style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: AppColors.darkColor,
            fontSize: isMultiLine ? 11.sp : 13.sp,
            fontWeight: isMultiLine ? FontWeight.w400 : FontWeight.w600,
            letterSpacing: 0),
        decoration: InputDecoration(
          label: Container(
            // width: double.infinity,
            // height: MediaQuery.of(context).size.height * 0.03,
            alignment: isMultiLine ? Alignment.topRight : Alignment.centerRight,
            child: Text(
              labelText,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.darkColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.14,
              ),
            ),
          ),

          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                      isHidden.value ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.primaryColor),
                  onPressed: () {
                    isHidden.value = !isHidden.value;
                  })
              : suffix,
          border: border(),
          // labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          // error: ,
          // labelStyle: TextStyle(
          //   color: AppColors.darkColor,
          //   fontSize: 16.sp,
          //   fontWeight: FontWeight.w600,
          //   letterSpacing: 0.14,
          // ),
          prefixIcon: prefix,
          prefixIconConstraints: BoxConstraints(
            minWidth: 40.w,
          ),
          prefixIconColor: AppColors.primaryColor,

          suffixIconColor: AppColors.primaryColor,
          focusedBorder: focusedborder(),

          enabledBorder: border(),
          errorBorder: border(),
          focusedErrorBorder: border(),
          disabledBorder: border(),
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(
            horizontal: prefix == null ? 12.w : 8.w,
            vertical: 12.h,
          ),
          filled: true,
          fillColor: isFocused.value ? const Color(0xffECF6FF) : Colors.white,
        ),
        cursorColor: Colors.black,
        cursorWidth: 1,
        focusNode: focusNode,
        showCursor: true,
        obscureText: isPassword && isHidden.value,
        validator: validator);
  }
}

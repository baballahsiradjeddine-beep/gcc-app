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
  final bool isReadOnly;
  final bool isMultiLine;
  final String? initialValue;

  const CustomTextFormField({
    super.key,
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
    this.isMultiLine = false,
    this.initialValue,
  }) : assert(initialValue == null || controller == null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHidden = useState<bool>(true);
    final focusNode = useFocusNode();
    final isFocused = useState<bool>(false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    useEffect(() {
      void listener() => isFocused.value = focusNode.hasFocus;
      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [focusNode]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8.w, bottom: 8.h),
          child: Text(
            labelText,
            style: TextStyle(
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'SomarSans',
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              if (isFocused.value)
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            readOnly: isReadOnly,
            initialValue: initialValue,
            focusNode: focusNode,
            keyboardType: keyboardType,
            textInputAction: textInputAction ?? TextInputAction.next,
            maxLines: isMultiLine ? 5 : 1,
            obscureText: isPassword && isHidden.value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1E293B),
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'SomarSans',
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                fontSize: 14.sp,
                fontFamily: 'SomarSans',
              ),
              prefixIcon: prefix != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: IconTheme(
                        data: IconThemeData(
                          color: isFocused.value ? AppColors.primaryColor : (isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8)),
                          size: 22.sp,
                        ),
                        child: prefix!,
                      ),
                    )
                  : null,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isHidden.value ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: isFocused.value ? AppColors.primaryColor : const Color(0xFF94A3B8),
                        size: 22.sp,
                      ),
                      onPressed: () => isHidden.value = !isHidden.value,
                    )
                  : suffix,
              filled: true,
              fillColor: isDark 
                  ? (isFocused.value ? const Color(0xFF1E293B) : const Color(0xFF0F172A))
                  : (isFocused.value ? Colors.white : const Color(0xFFF8FAFC)),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 20.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: const BorderSide(
                  color: Color(0xFFF43F5E),
                  width: 1.5,
                ),
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}

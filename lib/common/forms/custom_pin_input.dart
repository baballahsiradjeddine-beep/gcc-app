import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class CustomPinInput extends StatelessWidget {
  const CustomPinInput(
      {super.key,
      required this.pinController,
      this.onChanged,
      required this.isError,
      required this.isSubmitted});

  final TextEditingController pinController;
  final Function? onChanged;
  final bool isError;
  final bool isSubmitted;
  @override
  Widget build(BuildContext context) {
    getDecoration() {
      return BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(14.r)),
        border: Border.all(color: Colors.grey, width: .5),
      );
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: 6,
        closeKeyboardWhenCompleted: true,
        onClipboardFound: (val) {
          print('Clipboard Found');
        },
        defaultPinTheme: PinTheme(
            width: 60.w,
            height: 40.h,
            textStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
            decoration: getDecoration()),
        errorPinTheme: PinTheme(
            width: 100.w,
            height: 50.h,
            textStyle: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.red,
            ),
            decoration: getDecoration()),
        errorText: 'رمز التحقق غير صحيح',
        forceErrorState: isError,
        keyboardType: TextInputType.number,
        errorBuilder: (errorText, pin) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              errorText!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          );
        },
        submittedPinTheme: PinTheme(
            width: 100.w,
            height: 50.h,
            textStyle: TextStyle(
              fontSize: 18.sp,
              color: isSubmitted ? Colors.green : AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
            decoration: getDecoration()),
        controller: pinController,
        onCompleted: (String pin) {},
        onChanged: (String char) {
          if (onChanged != null) {
            onChanged!();
          }
        },
      ),
    );
  }
}

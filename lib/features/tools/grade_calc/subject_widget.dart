import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class SubjectWidget extends HookConsumerWidget {
  const SubjectWidget(
      {super.key,
      required this.subjectName,
      required this.subjectGrade,
      required this.subjectCoef,
      required this.onGradeChange});

  final String subjectName;
  final double subjectGrade;
  final int subjectCoef;
  final Function(double) onGradeChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Timer? debounce;
    final controller = useTextEditingController(
        text: subjectGrade == 0 ? null : subjectGrade.toString(),
        keys: [subjectName]);

    correctValue(decimal, value) {
      // TODO:can be optmized at some point
      final decimalValue = int.parse(decimal);
      if (decimalValue < 25) {
        controller.text = value.split('.')[0] + '.0';
      } else if (decimalValue < 50) {
        controller.text = value.split('.')[0] + '.25';
      } else if (decimalValue < 75) {
        controller.text = value.split('.')[0] + '.5';
      } else {
        controller.text = value.split('.')[0] + '.75';
      }
    }

    bool validateField(value) {
      if (value.isNotEmpty) {
        if (double.parse(value) > 20 || double.parse(value) < 0) {
          controller.clear();
          return false;
        }
        if (value.contains('.')) {
          final decimal = value.split('.')[1];
          if (decimal != '25' &&
              decimal != '5' &&
              decimal != '75' &&
              decimal != '0') {
            correctValue(decimal, value);
            return false;
          }
        }
      }
      return true;
    }

    buildBorder() {
      return OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.r),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: SizedBox(
        height: 34.h,
        child: Row(
          children: [
            Expanded(
                flex: 4,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(subjectName))),
            10.horizontalSpace,
            Expanded(
              flex: 2,
              child: TextFormField(
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.done,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    hintText: '0',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    focusedBorder: buildBorder(),
                    enabledBorder: buildBorder(),
                    errorBorder: buildBorder(),
                    focusedErrorBorder: buildBorder(),
                    disabledBorder: buildBorder()),

                style: TextStyle(fontSize: 12.sp),

                controller:
                    controller, // TextEditingController(text: subjectGrade.toString()),
                // onChanged: (value) {
                // if (validateField(value)) {
                // onGradeChange(double.parse(value));
                // } // onGradeChange(double.parse(value));

                //   if (debounce?.isActive ?? false) debounce!.cancel();
                //   debounce = Timer(const Duration(milliseconds: 2000), () {
                //     if (value.isNotEmpty) {
                //       onGradeChange(double.parse(value));
                //     }
                //   });
                // },
                onFieldSubmitted: (value) {
                  if (validateField(value)) {
                    onGradeChange(double.parse(value));
                  }
                },
                onTapOutside: (value) {
                  if (controller.text.isNotEmpty) {
                    controller.text = subjectGrade.toString();
                  }
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  // CustomRangeFormatter(),
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(subjectCoef.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffF037A5)))),
            ),
            10.horizontalSpace,
            Expanded(
              flex: 2,
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text((subjectGrade * subjectCoef).toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }
}

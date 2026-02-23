import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/custom_cached_image.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/exercice/presentation/view/select_right_option/latext_text_widget.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class ExerciceDialogContent extends HookWidget {
  const ExerciceDialogContent({
    super.key,
    required this.items,
    required this.title,
    this.hintImage,
  });

  final List<LatexField<String>> items;
  final String? hintImage;
  final String title;
  @override
  Widget build(BuildContext context) {
    final hintController = usePageController();
    final currentIndex = useState(0);
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.darkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  10.verticalSpace,
                  if (hintImage != null)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CustomCachedImage(
                        imageUrl: hintImage!,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  const Divider(
                    color: AppColors.greyColor,
                  ),
                  SizedBox(
                      height: 50.h,
                      child: PageView(
                        controller: hintController,
                        onPageChanged: (index) {
                          currentIndex.value = index;
                        },
                        children: items
                            .map((hint) => Center(
                                  child: LatextTextWidget(
                                      text: hint.text,
                                      isLatex: hint.isLatex,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                      textAlign: TextAlign.center,
                                      textStyle: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppColors.textBlack,
                                      )),
                                ))
                            .toList(),
                      )),
                  10.verticalSpace,
                  const Divider(
                    color: AppColors.greyColor,
                  ),
                  Text(
                    '${currentIndex.value + 1} -  ${items.length}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  10.verticalSpace,
                  BigButton(
                      text: AppStrings.continueText,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          ],
        ));
  }
}

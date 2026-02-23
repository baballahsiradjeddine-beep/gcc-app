import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/data/configs.dart';
import 'package:tayssir/common/push_buttons/pushable_button.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/custom_back_button.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/upload_button.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/upload_button_failure.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/upload_button_successful.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/upload_progress_button.dart';
import 'package:tayssir/features/subscriptions/presentation/state/paper/subscription_paper_controller.dart';
import 'package:tayssir/providers/user/subscription_model.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/services/actions/dialog_service.dart';
import 'package:tayssir/utils/extensions/async_value.dart';

enum UploadStatus {
  uploading,
  uploaded,
  error,
  none,
}

class SubscriptionPaperScreen extends HookConsumerWidget {
  const SubscriptionPaperScreen({super.key, required this.subscription});
  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = useState<UploadStatus>(UploadStatus.none);
    final progress = useState<double>(0);
    final file = useState<PlatformFile?>(null);
    final promotorCodeController = useTextEditingController();
    final price = subscription.price;
    final configs = ref.watch(configsProvider).requireValue;

    ref.listen(subscriptionPaperControllerProvider.select((v) => v.state),
        (prv, nxt) {
      nxt.handleSideThings(context, () {
        DialogService.showSubscriptionDialog(context, () {
          context.goNamed(AppRoutes.home.name);
        }, SubscrptionStatus.pending);
      }, shouldShowError: true);
    });
    pickFile() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        // allowedExtensions: [
        //   'jpg',
        //   'pdf',
        //   'doc',
        //   'png',
        //   'jpeg',
        //   'docx',

        // ],
      );

      if (result != null) {
        file.value = result.files.single;
        if (file.value!.size > 10 * 1024 * 1024) {
          status.value = UploadStatus.error;
          return;
        }
        status.value = UploadStatus.uploading;
      }
    }

    Widget getStatusWidget({required UploadStatus uploadStatus}) {
      switch (uploadStatus) {
        case UploadStatus.none:
          return UploadButton(
            onTap: () async {
              pickFile();
            },
          );
        case UploadStatus.uploading:
          return UploadProgressButton(
            current: progress.value,
            filename: file.value?.name ?? "",
            onStop: () {
              status.value = UploadStatus.none;
              file.value = null;
              progress.value = 0;
            },
          );
        case UploadStatus.uploaded:
          return UploadButtonSuccessful(
            filename: file.value?.name ?? "",
            fileSize: file.value?.size.toDouble() ?? 0,
          );
        case UploadStatus.error:
          return UploadButtonFailure(
            filename: file.value?.name ?? "",
            onTap: pickFile,
          );
      }
    }

    useEffect(() {
      Timer? timer;
      if (status.value == UploadStatus.uploading) {
        timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (progress.value < 100) {
            progress.value += 5;
          } else {
            status.value = UploadStatus.uploaded;
            timer.cancel();
          }
        });
      }
      return timer?.cancel;
    }, [status.value]);

    return AppScaffold(
      paddingY: 0,
      topSafeArea: false,
      body: SliverScrollingWidget(
        children: [
          50.verticalSpace,
          const CustomBackButton(),
          // const TitoAdviceWidget(text: AppStrings.goodChoice),
          10.verticalSpace,
          PushableButton(
            height: 120.h,
            elevation: 7,
            onPressed: null,
            hasBorder: false,
            hslColor: HSLColor.fromColor(const Color(0XFF175DC7)),
            borderRadius: 20,
            hslDisabledColor: HSLColor.fromColor(const Color(0XFF175DC7)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                20,
                15,
                20,
                10,
              ),
              decoration: const BoxDecoration(
                //gradiant
                gradient: LinearGradient(
                  colors: [
                    Color(0XFF175DC7),
                    Color(0XFF00C4F6),
                  ],
                ),
                //RADIUS
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ادفع لهذا الحساب :',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SvgPicture.asset(
                        SVGs.latestLogo,
                      )
                    ],
                  ),
                  // 5.verticalSpace,
                  // // text of 2500 da
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: Text(
                  //     // '2500 دج',
                  //     // convert to price
                  //     '${price.toStringAsFixed(0)} دج',
                  //     style: TextStyle(
                  //       color: Colors.white.withValues(alpha: 0.6),
                  //       fontSize: 18.sp,
                  //       fontWeight: FontWeight.w900,
                  //     ),
                  //   ),
                  // ),
                  12.verticalSpace,

                  // Container(
                  //   height: 35.h,
                  //   alignment: Alignment.center,
                  //   padding: EdgeInsets.symmetric(horizontal: 10.w),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: TextField(
                  //     textAlignVertical: TextAlignVertical.center,
                  //     keyboardType: TextInputType.number,
                  //     maxLength: 12,
                  //     onChanged: (value) {
                  //       controller.text = value;
                  //     },
                  //     style: TextStyle(
                  //         color: hasError ? Colors.red : Colors.black,
                  //         fontSize: 16,
                  //         letterSpacing: 10),
                  //     textAlign: TextAlign.center,
                  //     controller: controller,
                  //     decoration: const InputDecoration(
                  //       counterText: '',
                  //       contentPadding: EdgeInsets.only(bottom: 10),
                  //       border: InputBorder.none,
                  //       hintText: 'أدخل رقم البطاقة',
                  //       hintStyle: TextStyle(
                  //           color: Colors.grey, fontSize: 14, letterSpacing: 1),
                  //     ),
                  //   ),
                  // ),
                  // 10.verticalSpace,
                  // const Spacer(),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     'مع تيسيير الباك في الجيب Sur! 🚀✨',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 16.sp,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الاسم :',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              // 'SIRADJ EDDINE BABALLAH',
                              configs.paymentName ?? 'BAYAN E-LEARNING',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        8.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الحساب:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              // '00799999002888539926',
                              configs.paymentNumber ?? '0022500000000',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رفع إيصال الدفع',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                20.verticalSpace,
                getStatusWidget(uploadStatus: status.value),
              ],
            ),
          ),
          20.verticalSpace,
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      size: 20.w,
                      color: Colors.blue[600],
                    ),
                    8.horizontalSpace,
                    Text(
                      'كود المروج (اختياري)',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                TextFormField(
                  controller: promotorCodeController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'أدخل كود المروج',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide:
                          BorderSide(color: Colors.blue[600]!, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    prefixIcon: Icon(
                      Icons.discount,
                      color: Colors.grey[400],
                      size: 20.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          BigButton(
            text: AppStrings.check,
            onPressed: status.value == UploadStatus.uploaded
                ? () {
                    ref
                        .read(subscriptionPaperControllerProvider.notifier)
                        .subscribeWithPaper(
                          subscription: subscription,
                          promotorCode: promotorCodeController.text.isEmpty
                              ? null
                              : promotorCodeController.text,
                          file: File(file.value!.path!),
                        );
                  }
                : null,
          ),

          20.verticalSpace,
        ],
      ),
    );
  }
}

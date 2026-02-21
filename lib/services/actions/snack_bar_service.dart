import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/router/routes_service.dart';
import 'package:toastification/toastification.dart';

class SnackBarService {
  //singletoon
  SnackBarService._privateConstructor();
  static final SnackBarService instance = SnackBarService._privateConstructor();

  static void showSuccessSnackBar(
    String message, {
    BuildContext? context,
  }) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        elevation: 0,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'تم بنجاح',
          message: message,
          messageTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
          ),
          contentType: ContentType.success,
        ),
      ),
    );
    // final snackBar = SnackBar(
    //   elevation: 0,
    //   width: double.infinity,
    //   clipBehavior: Clip.antiAlias,
    //   duration: const Duration(milliseconds: 1500),
    //   behavior: SnackBarBehavior.floating,
    //   backgroundColor: Colors.transparent,
    //   content: AwesomeSnackbarContent(
    //     title: 'تم بنجاح',
    //     message: message,
    //     messageTextStyle: TextStyle(
    //       color: Colors.white,
    //       fontSize: 12.sp,
    //     ),
    //     contentType: ContentType.success,
    //   ),
    // );
    // if (context == null) return;
    // ScaffoldMessenger.of(context)
    //   ..hideCurrentSnackBar()
    //   ..showSnackBar(snackBar);
  }

  static void showSuccessToast(String message) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      title: Row(
        children: [
          Expanded(
            child: Text(message,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                )),
          ),
        ],
      ),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      icon: const Icon(
        Icons.check_circle_outline_outlined,
        color: Color(0xFF94F006),
        size: 30,
      ),
      showIcon: true,
      primaryColor: const Color(0xff272A2D),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      borderRadius: BorderRadius.circular(12),
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.always,
        buttonBuilder: (context, onClose) {
          return const Icon(
            Icons.close,
            color: Colors.white,
          );
        },
      ),
      closeOnClick: true,
      // callbacks: ToastificationCallbacks(
      //   onTap: (toastItem) => log('Toast ${toastItem.id} tapped'),
      //   onCloseButtonTap: (toastItem) =>
      //       log('Toast ${toastItem.id} close button tapped'),
      //   onAutoCompleteCompleted: (toastItem) =>
      //       log('Toast ${toastItem.id} auto complete completed'),
      //   onDismissed: (toastItem) => log('Toast ${toastItem.id} dismissed'),
      // ),
    );
  }

  static void showErrorToast(String message) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 4),
      title: Text(
        message,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      icon: const Icon(
        Icons.error_outline,
        color: Color(0xFFFF4444),
        size: 30,
      ),
      showIcon: true,
      primaryColor: const Color(0xff2D1B1B),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      borderRadius: BorderRadius.circular(12),
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.always,
        buttonBuilder: (context, onClose) {
          return const Icon(
            Icons.close,
            color: Colors.white,
          );
        },
      ),
      closeOnClick: true,
      // callbacks: ToastificationCallbacks(
      //   onTap: (toastItem) => log('Error Toast ${toastItem.id} tapped'),
      //   onCloseButtonTap:
      //       (toastItem) =>
      //           log('Error Toast ${toastItem.id} close button tapped'),
      //   onAutoCompleteCompleted:
      //       (toastItem) =>
      //           log('Error Toast ${toastItem.id} auto complete completed'),
      //   onDismissed:
      //       (toastItem) => log('Error Toast ${toastItem.id} dismissed'),
      // ),
    );
  }

  static void showErrorSnackBar(
    String message, {
    BuildContext? context,
  }) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        elevation: 0,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'حدث خطا',
          message: message,
          messageTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
          ),
          contentType: ContentType.failure,
        ),
      ),
    );
    // final snackBar = SnackBar(
    //   elevation: 0,
    //   width: double.infinity,
    //   clipBehavior: Clip.antiAlias,
    //   duration: const Duration(milliseconds: 1500),
    //   behavior: SnackBarBehavior.floating,
    //   backgroundColor: Colors.transparent,
    //   content: AwesomeSnackbarContent(
    //     title: 'حدث خطا',
    //     message: message,
    //     messageTextStyle: TextStyle(
    //       color: Colors.white,
    //       fontSize: 12.sp,
    //     ),
    //     contentType: ContentType.failure,
    //   ),
    //   // animation: ,
    // );
    // if (context == null) return;
    // ScaffoldMessenger.of(context)
    //   ..hideCurrentSnackBar()
    //   ..showSnackBar(snackBar);
  }
}

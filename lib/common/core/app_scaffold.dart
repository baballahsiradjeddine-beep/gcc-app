import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.paddingX,
    this.paddingY,
    this.paddingB,
    this.isScroll = false,
    this.onPopScope,
    this.resizeToAvoidBottomInset = false,
    this.includeBackButton = false,
    this.swipeBackEnabled = false,
    this.topSafeArea = true,
    this.extendBody = false,
    this.bodyBackgroundColor,
    this.floatingActionButton,
  });
  final Widget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final double? paddingX;
  final double? paddingY;
  final double? paddingB;
  final bool isScroll;
  final bool resizeToAvoidBottomInset;
  final bool includeBackButton;
  final bool swipeBackEnabled;
  final bool topSafeArea;
  final bool extendBody;
  final Color? bodyBackgroundColor;
  final Function()? onPopScope;

  @override
  Widget build(BuildContext context) {
    showPopup(BuildContext context, String message) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
        ),
      );
    }

        Widget bodyWidget = Padding(
          padding: EdgeInsets.fromLTRB(
              paddingX ?? 20.w,
              paddingY ?? 10.h, // Reduced from 20.h
              paddingX ?? 20.w,
              isScroll ? 0 : paddingB ?? paddingY ?? 10.h), // Reduced from 20.h
          child: appBar != null
              ? Column(
                  children: [
                    appBar!,
                    5.verticalSpace, // Reduced from 10.verticalSpace
                    Expanded(
                  child: isScroll
                      ? SingleChildScrollView(
                          child: body,
                        )
                      : body,
                ),
              ],
            )
          : isScroll
              ? SingleChildScrollView(
                  child: body,
                )
              : body,
    );

    if (swipeBackEnabled) {
      bodyWidget = GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity!.abs() > 1000) {
            if (details.primaryVelocity! > 0) {
              // showPopup(context, "You swiped RIGHT!");
              // if (context.canPop()) context.pop();
            } else if (details.primaryVelocity! < 0) {
              // showPopup(context, "You swiped LEFT!");
              if (context.canPop()) context.pop();
              // context.pop();
            }
          }
        },
        child: bodyWidget,
      );
    }

    return SafeArea(
      top: topSafeArea,
      bottom: false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: bodyBackgroundColor ?? (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC)),
            extendBody: extendBody,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            body: PopScope(
              canPop: onPopScope == null,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) {
                  onPopScope?.call();
                }
              },
              child: bodyWidget,
            ),
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar),
      ),
    );
  }
}

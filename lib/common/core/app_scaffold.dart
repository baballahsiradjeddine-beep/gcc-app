import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color bgColor = bodyBackgroundColor ??
        (isDark
            ? const Color(0xFF0B1120)
            : const Color(0xFFF1F5F9));

    Widget bodyWidget = Padding(
      padding: EdgeInsets.fromLTRB(
          paddingX ?? 20.w,
          paddingY ?? 16.h,
          paddingX ?? 20.w,
          isScroll ? 0 : paddingB ?? paddingY ?? 10.h),
      child: Column(
        children: [
          if (appBar != null || includeBackButton)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingX == 0 ? 20.w : 0),
              child: Row(
                children: [
                  if (appBar != null) Expanded(child: appBar!),
                  if (includeBackButton) ...[
                    if (appBar != null) 8.horizontalSpace,
                    IconButton(
                      onPressed: () {
                        if (onPopScope != null) {
                          onPopScope!();
                        } else if (context.canPop()) {
                          context.pop();
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Container(
                        width: 44.sp,
                        height: 44.sp,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.05),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          if (appBar != null || includeBackButton) 10.verticalSpace,
          Expanded(
            child: isScroll
                ? SingleChildScrollView(
                    child: body,
                  )
                : body,
          ),
        ],
      ),
    );

    if (swipeBackEnabled) {
      bodyWidget = GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity!.abs() > 1000) {
            if (details.primaryVelocity! < 0) {
              if (context.canPop()) context.pop();
            }
          }
        },
        child: bodyWidget,
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: bgColor,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: bgColor,
            extendBody: extendBody,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            body: PopScope(
              canPop: onPopScope == null,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop && onPopScope != null) {
                  onPopScope?.call();
                }
              },
              child: SafeArea(
                top: topSafeArea,
                bottom: false, // We handle bottom safety with the navigation bar color
                child: bodyWidget,
              ),
            ),
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
          ),
        ),
      ),
    );
  }
}

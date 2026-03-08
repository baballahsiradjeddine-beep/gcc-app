import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/core/app_scaffold.dart';

class BlurOverlayWidget extends StatelessWidget {
  final Widget child;
  final Widget overlayContent;
  final bool showOverlay;
  final EdgeInsets? padding;
  final VoidCallback? onPopScope;
  final bool hasTopSafeArea;
  const BlurOverlayWidget(
      {super.key,
      required this.child,
      this.padding,
      this.hasTopSafeArea = true,
      required this.overlayContent,
      required this.showOverlay,
      required this.onPopScope});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      topSafeArea: hasTopSafeArea,
      onPopScope: () {
        if (onPopScope != null) {
          onPopScope!();
        }
      },
      paddingX: 0,
      paddingY: 0,
      body: Stack(
        children: [
          Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
          if (showOverlay)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                // margin: const EdgeInsets.all(0),
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Padding(
                    padding: padding ?? EdgeInsets.all(20.r),
                    child: overlayContent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

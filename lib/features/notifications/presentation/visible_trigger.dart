import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VisibleTrigger extends StatelessWidget {
  const VisibleTrigger({
    super.key,
    required this.onVisible,
    required this.child,
  });

  final VoidCallback? onVisible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (visibilityInfo) {
        final isVisible = visibilityInfo.visibleFraction > 0.9;
        if (isVisible) onVisible?.call();
      },
      child: child,
    );
  }
}

import 'package:flutter/material.dart';

import 'animation_controller_state.dart';

class PushableImageButton extends StatefulWidget {
  const PushableImageButton({
    super.key,
    required this.image,
    required this.size,
    this.borderRadius = 20.0,
    this.topColor = Colors.blue,
    this.bottomColor,
    this.elevation = 8.0,
    this.borderWidth = 4.0,
    this.borderColor = Colors.white,
    this.onPressed,
    this.isCircle = false,
    this.icon,
  });

  final ImageProvider image;
  final double size;
  final bool isCircle;
  final Widget? icon;
  final double borderRadius;
  final Color topColor;
  final Color? bottomColor;
  final double elevation;
  final double borderWidth;
  final Color borderColor;
  final VoidCallback? onPressed;

  @override
  _PushableImageButtonState createState() =>
      _PushableImageButtonState(const Duration(milliseconds: 100));
}

class _PushableImageButtonState
    extends AnimationControllerState<PushableImageButton> {
  _PushableImageButtonState(super.duration);

  void _handleTapDown(TapDownDetails details) {
    animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    animationController.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final totalSize = widget.size + widget.elevation;
    final bottomColor =
        widget.bottomColor ?? widget.topColor.withValues(alpha: 0.7);

    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            final top = animationController.value * widget.elevation;
            return Stack(
              children: [
                // Bottom layer
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: totalSize,
                    height: totalSize - top,
                    decoration: BoxDecoration(
                      color: bottomColor,
                      shape: widget.isCircle
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      borderRadius: widget.isCircle
                          ? null
                          : BorderRadius.circular(widget.borderRadius),
                    ),
                  ),
                ),
                // Top (pushable) layer with image
                Positioned(
                  left: 0,
                  right: 0,
                  top: top,
                  child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        color: widget.topColor,
                        shape: widget.isCircle
                            ? BoxShape.circle
                            : BoxShape.rectangle,
                        borderRadius: widget.isCircle
                            ? null
                            : BorderRadius.circular(widget.borderRadius),
                        border: Border.all(
                          color: widget.borderColor,
                          width: widget.borderWidth,
                        ),
                        image: !widget.isCircle
                            ? DecorationImage(
                                image: widget.image,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: !widget.isCircle
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: widget.icon,
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: widget.icon,
                              ),
                            )),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

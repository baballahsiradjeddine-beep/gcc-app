import 'package:flutter/material.dart';

class PushableElevatedButton extends StatefulWidget {
  const PushableElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.style,
    this.elevation = 4.0,
    this.borderRadius = 20.0,
    this.height = 50.0,
    this.disableClick = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final double elevation;
  final double borderRadius;
  final double height;
  final bool disableClick;

  @override
  _PushableElevatedButtonState createState() => _PushableElevatedButtonState();
}

class _PushableElevatedButtonState extends State<PushableElevatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // void _handleTapDown(TapDownDetails details) {
  //   if (widget.disableClick) return;
  //   _animationController.forward();
  // }

  // void _handleTapUp(TapUpDetails details) {
  //   if (widget.disableClick) return;
  //   _animationController.reverse();
  //   widget.onPressed?.call();
  // }

  // void _handleTapCancel() {
  //   if (widget.disableClick) return;
  //   _animationController.reverse();
  // }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle effectiveStyle =
        widget.style ?? ElevatedButton.styleFrom();
    final backgroundColor =
        effectiveStyle.backgroundColor?.resolve({WidgetState.pressed}) ??
            Theme.of(context).primaryColor;
    final foregroundColor =
        effectiveStyle.foregroundColor?.resolve({WidgetState.pressed}) ??
            Colors.white;

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return GestureDetector(
            onTap: widget.onPressed,
            // onTapDown: _handleTapDown,
            // onTapUp: _handleTapUp,
            // onTapCancel: _handleTapCancel,
            child: Stack(
              children: [
                // Bottom layer
                Positioned.fill(
                  top: widget.elevation * _animation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                  ),
                ),
                // Top layer
                Transform.translate(
                  offset: Offset(0, widget.elevation * _animation.value),
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    child: ElevatedButton(
                      onPressed:
                          null, // We handle the onPressed in GestureDetector
                      style: effectiveStyle.copyWith(
                        elevation: WidgetStateProperty.all(0),
                        backgroundColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),

                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

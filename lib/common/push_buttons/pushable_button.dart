library pushable_button;

import 'package:flutter/material.dart';

import 'animation_controller_state.dart';

/// A widget to show a "3D" pushable button
class PushableButton extends StatefulWidget {
  const PushableButton({
    super.key,
    this.child,
    required this.hslColor,
    required this.height,
    this.hslDisabledColor = const HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.5),
    this.elevation = 8.0,
    this.borderRadius = 7.5,
    this.shadows,
    this.borderColor,
    this.onPressed,
    this.gradiantColors,
    this.disabledAnimation = false,
    this.allowDisabledClick = false,
    this.hasBorder = true,
    this.begin,
    this.useHslBottom = false,
    this.end,
  }) : assert(height > 0);

  /// child widget (normally a Text or Icon)
  final Widget? child;

  /// Color of the top layer
  /// The color of the bottom layer is derived by decreasing the luminosity by 0.15
  final HSLColor hslColor;

  final bool hasBorder;

  final double borderRadius;

  final HSLColor hslDisabledColor;

  /// height of the top layer
  final double height;

  /// elevation or "gap" between the top and bottom layer
  final double elevation;

  /// An optional shadow to make the button look better
  /// This is added to the bottom layer only
  final List<BoxShadow>? shadows;

  /// button pressed callback
  final VoidCallback? onPressed;

  final Color? borderColor;
  final bool disabledAnimation;
  final List<Color>? gradiantColors;
  final bool allowDisabledClick;
  final bool useHslBottom;
  // gradient alignment

  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  @override
  _PushableButtonState createState() =>
      _PushableButtonState(const Duration(milliseconds: 100));
}

class _PushableButtonState extends AnimationControllerState<PushableButton> {
  _PushableButtonState(super.duration);

  final bool _isDragInProgress = false;
  Offset _gestureLocation = Offset.zero;

  // Track if we're in a tap sequence
  bool _isTapInProgress = false;

  bool get _isAnimationDisabled {
    if (widget.allowDisabledClick) return false;
    return widget.disabledAnimation || widget.onPressed == null;
  }

  void _handleTapDown(TapDownDetails details) {
    if (_isAnimationDisabled) return;
    _gestureLocation = details.localPosition;
    _isTapInProgress = true;
    animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isAnimationDisabled) return;

    if (_isTapInProgress) {
      animationController.reverse();
      widget.onPressed?.call();
      _isTapInProgress = false;
    }
  }

  void _handleTapCancel() {
    if (_isAnimationDisabled) return;

    if (_isTapInProgress) {
      _isTapInProgress = false;
      animationController.reverse();
    }
  }

  // We no longer need horizontal/vertical drag handlers for button functionality

  @override
  Widget build(BuildContext context) {
    final totalHeight = widget.height + widget.elevation;

    // HSLColor buildBottomColor(){
    //build bottom color from hsl color like to be drop shadow of 2 colors , first is black with opacity 0.3 ,and second with the hsl color ,

    // }

    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonSize = Size(constraints.maxWidth, constraints.maxHeight);

          return GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                final top = animationController.value * widget.elevation;
                final hslColor = widget.hslColor;
                final newLightness = hslColor.lightness - 0.15 < 0.0
                    ? hslColor.lightness
                    : hslColor.lightness - 0.15;

                // AppLogger.logInfo(
                // 'the new color is ${widget.hslColor.withLightness(newLightness).toColor()}');
                final bottomHslColor = widget.onPressed == null
                    ? widget.allowDisabledClick
                        ? hslColor.withLightness(newLightness)
                        : widget.hslDisabledColor.withLightness(
                            widget.hslDisabledColor.lightness - 0.15)
                    : widget.allowDisabledClick
                        ? widget.hslDisabledColor.withLightness(
                            widget.hslDisabledColor.lightness - 0.15)
                        : widget.useHslBottom
                            ? widget.hslColor
                            : hslColor.withLightness(newLightness);

                final gColors = widget.gradiantColors;
                final finalShapeColor = widget.onPressed == null
                    ? widget.hslDisabledColor.toColor()
                    : gColors == null || gColors.length < 2
                        ? widget.allowDisabledClick
                            ? widget.hslDisabledColor.toColor()
                            : hslColor.toColor()
                        : null;

                final finalShapeGradient = widget.onPressed == null
                    ? null
                    : gColors == null || gColors.length < 2
                        ? null
                        : LinearGradient(
                            colors: widget.gradiantColors!,
                            begin: widget.begin ?? Alignment.topCenter,
                            end: widget.end ?? Alignment.bottomCenter,
                          );

                final customDecoration = ShapeDecoration(
                    color: finalShapeColor,
                    gradient: finalShapeGradient,
                    shadows: widget.shadows ?? [],
                    shape: RoundedRectangleBorder(
                        side: widget.hasBorder
                            ? BorderSide(
                                color: widget.borderColor ?? Colors.grey,
                                width: widget.borderColor != null ? 1.2 : 0.3,
                                style: BorderStyle.solid)
                            : BorderSide.none,
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius)));
                return Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: totalHeight - top,
                        decoration: BoxDecoration(
                          // color: widget.borderColor ?? bottomHslColor.toColor(),
                          color: widget.borderColor ?? bottomHslColor.toColor(),
                          // can use gradinet here if i want to

                          borderRadius:
                              BorderRadius.circular(widget.borderRadius),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: top,
                      child: Container(
                        // alignment: Alignment.center,
                        height: widget.height,
                        decoration: customDecoration,
                        child: Center(child: widget.child),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// library pushable_button;

// import 'package:flutter/material.dart';

// import 'animation_controller_state.dart';

// /// A widget to show a "3D" pushable button
// class PushableButton extends StatefulWidget {
//   const PushableButton({
//     super.key,
//     this.child,
//     required this.hslColor,
//     required this.height,
//     this.hslDisabledColor = const HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.5),
//     this.elevation = 8.0,
//     this.borderRadius = 7.5,
//     this.shadow,
//     this.borderColor,
//     this.onPressed,
//     this.gradiantColors,
//     this.disabledAnimation = false,
//     this.allowDisabledClick = false,
//   }) : assert(height > 0);

//   /// child widget (normally a Text or Icon)
//   final Widget? child;

//   /// Color of the top layer
//   /// The color of the bottom layer is derived by decreasing the luminosity by 0.15
//   final HSLColor hslColor;

//   final double borderRadius;

//   final HSLColor hslDisabledColor;

//   /// height of the top layer
//   final double height;

//   /// elevation or "gap" between the top and bottom layer
//   final double elevation;

//   /// An optional shadow to make the button look better
//   /// This is added to the bottom layer only
//   final BoxShadow? shadow;

//   /// button pressed callback
//   final VoidCallback? onPressed;

//   final Color? borderColor;
//   final bool disabledAnimation;
//   final List<Color>? gradiantColors;
//   final bool allowDisabledClick;
//   @override
//   _PushableButtonState createState() =>
//       _PushableButtonState(const Duration(milliseconds: 100));
// }

// class _PushableButtonState extends AnimationControllerState<PushableButton> {
//   _PushableButtonState(super.duration);

//   bool _isDragInProgress = false;
//   Offset _gestureLocation = Offset.zero;

//   bool get _isAnimationDisabled {
//     if (widget.allowDisabledClick) return false;
//     return widget.disabledAnimation || widget.onPressed == null;
//   }

//   void _handleTapDown(TapDownDetails details) {
//     if (_isAnimationDisabled) return;
//     _gestureLocation = details.localPosition;
//     animationController.forward();
//   }

//   void _handleTapUp(TapUpDetails details) {
//     if (_isAnimationDisabled) return;

//     animationController.reverse();
//     widget.onPressed?.call();
//   }

//   void _handleTapCancel() {
//     if (_isAnimationDisabled) return;

//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (!_isDragInProgress && mounted) {
//         animationController.reverse();
//       }
//     });
//   }

//   void _handleDragStart(DragStartDetails details) {
//     if (_isAnimationDisabled) return;

//     _gestureLocation = details.localPosition;
//     _isDragInProgress = true;
//     animationController.forward();
//   }

//   void _handleDragEnd(Size buttonSize) {
//     if (_isAnimationDisabled) return;
//     //print('drag end (in progress: $_isDragInProgress)');
//     if (_isDragInProgress) {
//       _isDragInProgress = false;
//       animationController.reverse();
//     }
//     if (_gestureLocation.dx >= 0 &&
//         _gestureLocation.dy < buttonSize.width &&
//         _gestureLocation.dy >= 0 &&
//         _gestureLocation.dy < buttonSize.height) {
//       if (_isAnimationDisabled) return;

//       widget.onPressed?.call();
//     }
//   }

//   void _handleDragCancel() {
//     if (_isAnimationDisabled) return;
//     if (_isDragInProgress) {
//       _isDragInProgress = false;
//       animationController.reverse();
//     }
//   }

//   void _handleDragUpdate(DragUpdateDetails details) {
//     if (_isAnimationDisabled) return;
//     _gestureLocation = details.localPosition;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totalHeight = widget.height + widget.elevation;

//     return SizedBox(
//       height: totalHeight,
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final buttonSize = Size(constraints.maxWidth, constraints.maxHeight);
//           return GestureDetector(
//             onTapDown: _handleTapDown,
//             onTapUp: _handleTapUp,
//             onTapCancel: _handleTapCancel,
//             onHorizontalDragStart: _handleDragStart,
//             onHorizontalDragEnd: (_) => _handleDragEnd(buttonSize),
//             onHorizontalDragCancel: _handleDragCancel,
//             onHorizontalDragUpdate: _handleDragUpdate,
//             onVerticalDragStart: _handleDragStart,
//             onVerticalDragEnd: (_) => _handleDragEnd(buttonSize),
//             onVerticalDragCancel: _handleDragCancel,
//             onVerticalDragUpdate: _handleDragUpdate,
//             child: AnimatedBuilder(
//               animation: animationController,
//               builder: (context, child) {
//                 final top = animationController.value * widget.elevation;
//                 final hslColor = widget.hslColor;

//                 final bottomHslColor = widget.onPressed == null
//                     ? widget.allowDisabledClick
//                         ? hslColor.withLightness(hslColor.lightness - 0.15)
//                         : widget.hslDisabledColor.withLightness(
//                             widget.hslDisabledColor.lightness - 0.15)
//                     : widget.allowDisabledClick
//                         ? widget.hslDisabledColor.withLightness(
//                             widget.hslDisabledColor.lightness - 0.15)
//                         : hslColor.withLightness(hslColor.lightness - 0.15);

//                 final gColors = widget.gradiantColors;
//                 final finalShapeColor = widget.onPressed == null
//                     ? widget.hslDisabledColor.toColor()
//                     : gColors == null || gColors.length < 2
//                         ? widget.allowDisabledClick
//                             ? widget.hslDisabledColor.toColor()
//                             : hslColor.toColor()
//                         : null;

//                 final finalShapeGradient = widget.onPressed == null
//                     ? null
//                     : gColors == null || gColors.length < 2
//                         ? null
//                         : LinearGradient(
//                             colors: widget.gradiantColors!,
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           );

//                 final customDecoration = ShapeDecoration(
//                     color: finalShapeColor,
//                     gradient: finalShapeGradient,
//                     shape: RoundedRectangleBorder(
//                         side: BorderSide(
//                             color: widget.borderColor ?? Colors.grey,
//                             width: widget.borderColor != null ? 1.2 : 0.3,
//                             style: BorderStyle.solid),
//                         borderRadius:
//                             BorderRadius.circular(widget.borderRadius)));
//                 return Stack(
//                   children: [
//                     Positioned(
//                       left: 0,
//                       right: 0,
//                       bottom: 0,
//                       child: Container(
//                         height: totalHeight - top,
//                         decoration: BoxDecoration(
//                           color: widget.borderColor ?? bottomHslColor.toColor(),
//                           boxShadow:
//                               widget.shadow != null ? [widget.shadow!] : [],
//                           //TODO: make the border radius configurable
//                           borderRadius:
//                               BorderRadius.circular(widget.borderRadius),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: 0,
//                       right: 0,
//                       top: top,
//                       child: Container(
//                         height: widget.height,
//                         decoration: customDecoration,
//                         child: Center(child: widget.child),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// library pushable_button;

// import 'package:flutter/material.dart';

// import 'animation_controller_state.dart';

// /// A widget to show a "3D" pushable button
// class PushableButton extends StatefulWidget {
//   const PushableButton({
//     super.key,
//     this.child,
//     required this.hslColor,
//     required this.height,
//     this.hslDisabledColor = const HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.5),
//     this.elevation = 8.0,
//     this.borderRadius = 7.5,
//     this.shadow,
//     this.borderColor,
//     this.onPressed,
//     this.gradiantColors,
//     this.disabledAnimation = false,
//     this.allowDisabledClick = false,
//   }) : assert(height > 0);

//   /// child widget (normally a Text or Icon)
//   final Widget? child;

//   /// Color of the top layer
//   /// The color of the bottom layer is derived by decreasing the luminosity by 0.15
//   final HSLColor hslColor;

//   final double borderRadius;

//   final HSLColor hslDisabledColor;

//   /// height of the top layer
//   final double height;

//   /// elevation or "gap" between the top and bottom layer
//   final double elevation;

//   /// An optional shadow to make the button look better
//   /// This is added to the bottom layer only
//   final BoxShadow? shadow;

//   /// button pressed callback
//   final VoidCallback? onPressed;

//   final Color? borderColor;
//   final bool disabledAnimation;
//   final List<Color>? gradiantColors;
//   final bool allowDisabledClick;
//   @override
//   _PushableButtonState createState() =>
//       _PushableButtonState(const Duration(milliseconds: 100));
// }

// class _PushableButtonState extends AnimationControllerState<PushableButton> {
//   _PushableButtonState(super.duration);

//   bool _isDragInProgress = false;
//   Offset _gestureLocation = Offset.zero;

//   bool get _isAnimationDisabled {
//     if (widget.allowDisabledClick) return false;
//     return widget.disabledAnimation || widget.onPressed == null;
//   }

//   void _handleTapDown(TapDownDetails details) {
//     if (_isAnimationDisabled) return;
//     _gestureLocation = details.localPosition;
//     animationController.forward();
//   }

//   void _handleTapUp(TapUpDetails details) {
//     if (_isAnimationDisabled) return;

//     animationController.reverse();
//     widget.onPressed?.call();
//   }

//   void _handleTapCancel() {
//     if (_isAnimationDisabled) return;

//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (!_isDragInProgress && mounted) {
//         animationController.reverse();
//       }
//     });
//   }

//   void _handleDragStart(DragStartDetails details) {
//     if (_isAnimationDisabled) return;

//     _gestureLocation = details.localPosition;
//     _isDragInProgress = true;
//     animationController.forward();
//   }

//   void _handleDragEnd(Size buttonSize) {
//     if (_isAnimationDisabled) return;
//     //print('drag end (in progress: $_isDragInProgress)');
//     if (_isDragInProgress) {
//       _isDragInProgress = false;
//       animationController.reverse();
//     }
//     if (_gestureLocation.dx >= 0 &&
//         _gestureLocation.dy < buttonSize.width &&
//         _gestureLocation.dy >= 0 &&
//         _gestureLocation.dy < buttonSize.height) {
//       if (_isAnimationDisabled) return;

//       widget.onPressed?.call();
//     }
//   }

//   void _handleDragCancel() {
//     if (_isAnimationDisabled) return;
//     if (_isDragInProgress) {
//       _isDragInProgress = false;
//       animationController.reverse();
//     }
//   }

//   void _handleDragUpdate(DragUpdateDetails details) {
//     if (_isAnimationDisabled) return;
//     _gestureLocation = details.localPosition;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totalHeight = widget.height + widget.elevation;

//     return SizedBox(
//       height: totalHeight,
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final buttonSize = Size(constraints.maxWidth, constraints.maxHeight);
//           return GestureDetector(
//             onTapDown: _handleTapDown,
//             onTapUp: _handleTapUp,
//             onTapCancel: _handleTapCancel,
//             onHorizontalDragStart: _handleDragStart,
//             onHorizontalDragEnd: (_) => _handleDragEnd(buttonSize),
//             onHorizontalDragCancel: _handleDragCancel,
//             onHorizontalDragUpdate: _handleDragUpdate,
//             onVerticalDragStart: _handleDragStart,
//             onVerticalDragEnd: (_) => _handleDragEnd(buttonSize),
//             onVerticalDragCancel: _handleDragCancel,
//             onVerticalDragUpdate: _handleDragUpdate,
//             child: AnimatedBuilder(
//               animation: animationController,
//               builder: (context, child) {
//                 final top = animationController.value * widget.elevation;
//                 final hslColor = widget.hslColor;

//                 final bottomHslColor = widget.onPressed == null
//                     ? widget.allowDisabledClick
//                         ? hslColor.withLightness(hslColor.lightness - 0.15)
//                         : widget.hslDisabledColor.withLightness(
//                             widget.hslDisabledColor.lightness - 0.15)
//                     : widget.allowDisabledClick
//                         ? widget.hslDisabledColor.withLightness(
//                             widget.hslDisabledColor.lightness - 0.15)
//                         : hslColor.withLightness(hslColor.lightness - 0.15);

//                 //TODO: What have i just did here is bad and i did it just to speed things up , will  refector this later on
//                 final gColors = widget.gradiantColors;
//                 final finalShapeColor = widget.onPressed == null
//                     ? widget.allowDisabledClick
//                         ? widget.hslDisabledColor.toColor()
//                         : hslColor.toColor()
//                     : gColors == null || gColors.length < 2
//                         ? widget.allowDisabledClick
//                             ? widget.hslDisabledColor.toColor()
//                             : hslColor.toColor()
//                         : null;

//                 final finalShapeGradient = widget.onPressed == null
//                     ? null
//                     : gColors == null || gColors.length < 2
//                         ? null
//                         : LinearGradient(
//                             colors: widget.gradiantColors!,
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           );

//                 final customDecoration = ShapeDecoration(
//                     color: Colors.red,
//                     gradient: finalShapeGradient,
//                     shape: RoundedRectangleBorder(
//                         side: BorderSide(
//                             color: widget.borderColor ?? Colors.grey,
//                             width: widget.borderColor != null ? 1.2 : 0.3,
//                             style: BorderStyle.solid),
//                         borderRadius:
//                             BorderRadius.circular(widget.borderRadius)));
//                 return Stack(
//                   children: [
//                     Positioned(
//                       left: 0,
//                       right: 0,
//                       bottom: 0,
//                       child: Container(
//                         height: totalHeight - top,
//                         decoration: BoxDecoration(
//                           color: widget.borderColor ?? bottomHslColor.toColor(),
//                           boxShadow:
//                               widget.shadow != null ? [widget.shadow!] : [],
//                           borderRadius:
//                               BorderRadius.circular(widget.borderRadius),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: 0,
//                       right: 0,
//                       top: top,
//                       child: Container(
//                         height: widget.height,
//                         decoration: customDecoration,
//                         child: Center(child: widget.child),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

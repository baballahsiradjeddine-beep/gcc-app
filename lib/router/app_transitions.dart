import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'dart:math' as math;

class AppTransitions {
  // Fade transition
  static CustomTransitionPage<T> fadeTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCubic).animate(animation),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  // Slide transition
  static CustomTransitionPage<T> slideTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    SlideDirection direction = SlideDirection.right,
    Duration duration = const Duration(milliseconds: 450),
  }) {
    Offset begin;

    switch (direction) {
      case SlideDirection.right:
        begin = const Offset(1.0, 0.0);
        break;
      case SlideDirection.left:
        begin = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.up:
        begin = const Offset(0.0, 1.0);
        break;
      case SlideDirection.down:
        begin = const Offset(0.0, -1.0);
        break;
    }

    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuart,
          )),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  // Scale transition
  static CustomTransitionPage<T> scaleTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurveTween(curve: Curves.easeOutBack).animate(animation),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  // Cool combined transition
  static CustomTransitionPage<T> coolTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.7, curve: Curves.easeInOutCubic),
            ),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutQuart,
              ),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  // Modern Blur Transition (popular in iOS apps)
  static CustomTransitionPage<T> blurTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: (1 - animation.value) * 10,
            sigmaY: (1 - animation.value) * 10,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  // 3D Flip Transition (trending in mobile apps)
  static CustomTransitionPage<T> flipTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 600),
    FlipDirection flipDirection = FlipDirection.horizontal,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final rotate = Tween(
                begin: 0.0,
                end: flipDirection == FlipDirection.horizontal ? 1.0 : 0.5)
            .animate(CurvedAnimation(
                parent: animation, curve: Curves.easeInOutQuart));

        return AnimatedBuilder(
          animation: rotate,
          child: child,
          builder: (context, child) {
            final isHorizontal = flipDirection == FlipDirection.horizontal;
            final value = isHorizontal ? rotate.value : rotate.value;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(isHorizontal ? math.pi * value : 0)
                ..rotateX(isHorizontal ? 0 : math.pi * value),
              child: child,
            );
          },
        );
      },
      transitionDuration: duration,
    );
  }

  // Material 3 Shared Axis Transition (Google's latest design style)
  static CustomTransitionPage<T> sharedAxisTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            const double begin = 1.0;
            const double end = 0.0;
            final double fadeValue = Tween<double>(begin: 0.0, end: 1.0)
                .animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic))
                .value;

            double dx = 0.0;
            double dy = 0.0;
            double scale = 1.0;

            switch (type) {
              case SharedAxisTransitionType.horizontal:
                dx = Tween<double>(begin: 40.0 * begin, end: 0.0)
                    .animate(CurvedAnimation(
                        parent: animation, curve: Curves.easeOutQuart))
                    .value;
                break;
              case SharedAxisTransitionType.vertical:
                dy = Tween<double>(begin: 40.0 * begin, end: 0.0)
                    .animate(CurvedAnimation(
                        parent: animation, curve: Curves.easeOutQuart))
                    .value;
                break;
              case SharedAxisTransitionType.scaled:
                scale = Tween<double>(begin: 0.92, end: 1.0)
                    .animate(CurvedAnimation(
                        parent: animation, curve: Curves.easeOutQuart))
                    .value;
                break;
            }

            return Opacity(
              opacity: fadeValue,
              child: Transform.translate(
                offset: Offset(dx, dy),
                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              ),
            );
          },
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  // Staggered Fade Through Transition (Trending in modern mobile UI)
  static CustomTransitionPage<T> fadeThroughTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  // Container Transform (Material Motion)
  static CustomTransitionPage<T> containerTransformTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Alignment alignment = Alignment.center,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
        ));

        return Align(
          alignment: alignment,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  // Slide Fade Transition (Popular in e-commerce apps)
  static CustomTransitionPage<T> slideFadeTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
    SlideDirection direction = SlideDirection.up,
  }) {
    Offset begin;

    switch (direction) {
      case SlideDirection.right:
        begin = const Offset(0.25, 0.0);
        break;
      case SlideDirection.left:
        begin = const Offset(-0.25, 0.0);
        break;
      case SlideDirection.up:
        begin = const Offset(0.0, 0.25);
        break;
      case SlideDirection.down:
        begin = const Offset(0.0, -0.25);
        break;
    }

    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeOutCubic).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: begin,
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }
}

enum SlideDirection {
  right,
  left,
  up,
  down,
}

enum FlipDirection {
  horizontal,
  vertical,
}

enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}

// Helper class for FadeThroughTransition
class FadeThroughTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const FadeThroughTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([animation, secondaryAnimation]),
      builder: (context, child) {
        final fadeIn = const Interval(0.5, 1.0, curve: Curves.easeInOut)
            .transform(animation.value);
        final fadeOut = const Interval(0.0, 0.5, curve: Curves.easeIn)
            .transform(1 - secondaryAnimation.value);
        final opacity = fadeIn + fadeOut;

        final scale = Tween<double>(begin: 0.92, end: 1.0)
            .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic))
            .value;

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class TayssirCustomGoRoute extends GoRoute {
  final TransitionType transitionType;
  final SlideDirection slideDirection;
  final Duration duration;
  final FlipDirection flipDirection;
  final SharedAxisTransitionType sharedAxisType;
  final Alignment containerAlignment;

  TayssirCustomGoRoute({
    required super.path,
    required super.name,
    super.routes,
    GlobalKey<NavigatorState>? parentNavigatorKey,
    required Widget Function(BuildContext, GoRouterState) pageBuilder,
    this.transitionType = TransitionType.fade,
    this.slideDirection = SlideDirection.right,
    this.flipDirection = FlipDirection.horizontal,
    this.sharedAxisType = SharedAxisTransitionType.horizontal,
    this.containerAlignment = Alignment.center,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
            parentNavigatorKey: parentNavigatorKey,
            pageBuilder: (context, state) {
              final page = pageBuilder(context, state);
              switch (transitionType) {
                case TransitionType.fade:
                  return AppTransitions.fadeTransition(
                    context: context,
                    state: state,
                    child: page,
                    duration: duration,
                  );
                case TransitionType.slide:
                  return AppTransitions.slideTransition(
                    context: context,
                    state: state,
                    child: page,
                    direction: slideDirection,
                    duration: duration,
                  );
                case TransitionType.scale:
                  return AppTransitions.scaleTransition(
                    context: context,
                    state: state,
                    child: page,
                    duration: duration,
                  );
                case TransitionType.cool:
                  return AppTransitions.coolTransition(
                    context: context,
                    state: state,
                    child: page,
                    duration: duration,
                  );
                case TransitionType.blur:
                  return AppTransitions.blurTransition(
                    context: context,
                    state: state,
                    child: page,
                    duration: duration,
                  );
                case TransitionType.flip:
                  return AppTransitions.flipTransition(
                    context: context,
                    state: state,
                    child: page,
                    flipDirection: flipDirection,
                    duration: duration,
                  );
                case TransitionType.sharedAxis:
                  return AppTransitions.sharedAxisTransition(
                    context: context,
                    state: state,
                    child: page,
                    type: sharedAxisType,
                    duration: duration,
                  );
                case TransitionType.fadeThrough:
                  return AppTransitions.fadeThroughTransition(
                    context: context,
                    state: state,
                    child: page,
                    duration: duration,
                  );
                case TransitionType.containerTransform:
                  return AppTransitions.containerTransformTransition(
                    context: context,
                    state: state,
                    child: page,
                    alignment: containerAlignment,
                    duration: duration,
                  );
                case TransitionType.slideFade:
                  return AppTransitions.slideFadeTransition(
                    context: context,
                    state: state,
                    child: page,
                    direction: slideDirection,
                    duration: duration,
                  );
              }
            });
}

enum TransitionType {
  fade,
  slide,
  scale,
  cool,
  blur,
  flip,
  sharedAxis,
  fadeThrough,
  containerTransform,
  slideFade,
}

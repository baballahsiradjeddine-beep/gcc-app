import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DummySlider extends HookWidget {
  const DummySlider({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.grey.withValues(alpha:.5),
            trackShape: const RectangularSliderTrackShape(),
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
          ),
          child: Slider(
            value: animation.value,
            max: 1.0,
            onChanged: (double newValue) {},
          ),
        );
      },
    );
  }
}

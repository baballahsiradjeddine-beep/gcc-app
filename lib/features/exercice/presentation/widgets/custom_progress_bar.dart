import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
        thumbColor: Colors.lightBlue,
        activeTrackColor: Colors.lightBlue,
        inactiveTrackColor: Colors.grey[300],
        trackHeight: 8.0,
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: Slider(
        value: 0.3, // Example value, set this dynamically as needed
        onChanged: (value) {},
      ),
    );
  }
}

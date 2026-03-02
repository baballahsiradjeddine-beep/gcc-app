import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'chat_bottom_sheet.dart';

class TitoSupportFab extends StatelessWidget {
  const TitoSupportFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true, 
          backgroundColor: Colors.transparent,
          builder: (context) => const ChatBottomSheet(),
        );
      },
      backgroundColor: const Color(0xFF00B4D8),
      elevation: 8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background aura
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00B4D8).withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ],
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 1.seconds),
          
          Text(
            '🐬',
            style: TextStyle(fontSize: 32.sp),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).rotate(begin: -0.05, end: 0.05, duration: 2.seconds, curve: Curves.easeInOutSine),
        ],
      ),
    ).animate().fadeIn(delay: 1.seconds).scale(delay: 1.seconds);
  }
}

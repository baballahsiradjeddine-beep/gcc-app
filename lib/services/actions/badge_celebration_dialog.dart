import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BadgeCelebrationDialog extends HookConsumerWidget {
  final String badgeName;
  final String badgeIconUrl;
  final Color badgeColor;

  const BadgeCelebrationDialog({
    super.key,
    required this.badgeName,
    required this.badgeIconUrl,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundOn = ref.watch(isSoundEnabledProvider);

    useEffect(() {
      if (isSoundOn) {
        SoundService.playLevelComplete();
      }
      return null;
    }, []);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(24.w),
          padding: EdgeInsets.all(32.w),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.85),
            borderRadius: BorderRadius.circular(40.r),
            border: Border.all(color: badgeColor.withOpacity(0.4), width: 2),
            boxShadow: [
              BoxShadow(
                color: badgeColor.withOpacity(0.2),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "إنجاز جديد رائع! 🏆",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
              30.verticalSpace,
              
              // Badge Icon with Glow and Particles
              Stack(
                alignment: Alignment.center,
                children: [
                   // Outer Glow
                  Container(
                    width: 140.w,
                    height: 140.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: badgeColor.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  
                  // The Badge
                  CachedNetworkImage(
                    imageUrl: badgeIconUrl,
                    width: 120.w,
                    height: 120.w,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.star, size: 80, color: Colors.amber),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                   .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds, curve: Curves.easeInOut)
                   .rotate(begin: -0.05, end: 0.05, duration: 2.seconds, curve: Curves.easeInOut)
                   .shimmer(delay: 1.seconds, duration: 2.seconds),
                ],
              ),
              
              30.verticalSpace,
              
              Text(
                "لقد حصلت على رتبة",
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 16.sp,
                  fontFamily: 'SomarSans',
                ),
              ),
              
              Text(
                badgeName,
                style: TextStyle(
                  color: badgeColor,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                  letterSpacing: 1,
                  shadows: [
                    Shadow(color: badgeColor.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 4))
                  ]
                ),
              ),
              
              40.verticalSpace,
              
              BigButton(
                text: "شكراً لك!",
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ).animate().scale(begin: const Offset(0.7, 0.7), curve: Curves.easeOutBack, duration: 600.ms).fadeIn(),
      ),
    );
  }
}

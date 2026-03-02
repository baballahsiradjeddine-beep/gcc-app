import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/features/challanges/presentation/widgets/challenge_mode_landing.dart';

class ChallengesScreen extends HookConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ChallengeModeLanding(
        key: const ValueKey("landing"),
        onEnterMode: () {
          // Push to the newly created dashboard route which is outside of the bottom nav scope
          context.pushNamed(AppRoutes.challengeDashboard.name);
        },
      ),
    );
  }
}

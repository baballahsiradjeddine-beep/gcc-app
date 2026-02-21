import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/push_buttons/rounded_pushable_button.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/router/app_router.dart';

class ProfileButton extends ConsumerWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref
            .watch(userNotifierProvider)
            .asData
            ?.value
            ?.completeProfilePic ??
        AppConsts.defaultImageUrl;
    return PushableImageButton(
      image: CachedNetworkImageProvider(
        url,
      ),
      size: 40,
      borderRadius: 15,
      topColor: const Color(0xff00C4F6),
      bottomColor: const Color(0xff1F7ACA),
      elevation: 3,
      borderWidth: 2,
      borderColor: Colors.blue,
      onPressed: () {
        ref.read(specialEffectServiceProvider).playEffects();

        context.pushNamed(AppRoutes.profile.name);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/data/know_options/know_option_model.dart';
import 'package:tayssir/features/auth/data/know_options/know_option_repository.dart';
import 'package:tayssir/features/auth/presentation/register/state/register_controller.dart';
import 'package:tayssir/utils/extensions/context.dart';

import '../widgets/option_selection.dart';
import '../../../../../common/tito_advice_widget.dart';

final knowOptionsProvider = FutureProvider<List<KnowOptionModel>>((ref) async {
  final repository = ref.watch(knowOptionRepositoryProvider);
  return await repository.getKnowOptions();
});

class KnowUsView extends HookConsumerWidget {
  const KnowUsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final List<KnowOption> knowOptions = [
    //   const KnowOption(value: AppStrings.facebook, icon: SVGs.icFacebook),
    //   const KnowOption(value: AppStrings.instagram, icon: SVGs.icInstagram),
    //   const KnowOption(value: AppStrings.youtube, icon: SVGs.icYoutube),
    //   const KnowOption(value: AppStrings.tiktok, icon: SVGs.icTiktok),
    //   const KnowOption(value: AppStrings.teachers, icon: SVGs.icTeacher),
    //   const KnowOption(
    //       value: AppStrings.contentCreators, icon: SVGs.icContentCreator),
    // ];
    final knowOptions = ref.watch(knowOptionsProvider);
    final selectedKnowOption = useState<int?>(null);
    return AppScaffold(
      body: knowOptions.when(
        data: (options) => SliverScrollingWidget(
          header: const TitoAdviceWidget(
            text: AppStrings.fromWhereYouKnowTayssir,
          ),
          children: [
            10.verticalSpace,
            ...List.generate(
              options.length,
              (index) => OptionSelection(
                iconPath: options[index].icon,
                text: options[index].name,
                onPressed: () {
                  selectedKnowOption.value = options[index].id;
                },
                isSelected: selectedKnowOption.value != null &&
                    selectedKnowOption.value == options[index].id,
              ),
            ),
            const Spacer(),
            if (context.isMediumDevice || context.isSmallDevice)
              50.verticalSpace,
            BigButton(
              text: AppStrings.continueText,
              onPressed: selectedKnowOption.value != null &&
                      !ref.watch(registerControllerProvider).isLoading
                  ? () {
                      ref
                          .read(registerControllerProvider.notifier)
                          .setKnowOption(selectedKnowOption.value!);
                    }
                  : null,
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

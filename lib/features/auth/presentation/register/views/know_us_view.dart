import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/data/know_options/know_option_model.dart';
import 'package:tayssir/features/auth/data/know_options/know_option_repository.dart';
import 'package:tayssir/features/auth/presentation/register/state/register_controller.dart';
import '../widgets/option_selection.dart';
import '../../../../../common/tito_advice_widget.dart';
import '../../common/header_text.dart';

final knowOptionsProvider = FutureProvider<List<KnowOptionModel>>((ref) async {
  final repository = ref.watch(knowOptionRepositoryProvider);
  return await repository.getKnowOptions();
});

class KnowUsView extends HookConsumerWidget {
  const KnowUsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final knowOptions = ref.watch(knowOptionsProvider);
    final selectedKnowOption = useState<int?>(null);

    return AppScaffold(
      body: knowOptions.when(
        data: (options) => SliverScrollingWidget(
          children: [
            24.verticalSpace,
            const HeaderText(text: "من أين عرفتنا ؟")
                .animate().fadeIn().slideY(begin: -0.1, end: 0),
            
            32.verticalSpace,
            
            const TitoAdviceWidget(
              text: AppStrings.fromWhereYouKnowTayssir,
              isHorizontal: false,
            ).animate().fadeIn(delay: 100.ms).scale(curve: Curves.easeOutBack),
            
            40.verticalSpace,
            
            ...List.generate(
              options.length,
              (index) => OptionSelection(
                iconPath: options[index].icon,
                text: options[index].name,
                onPressed: () {
                  selectedKnowOption.value = options[index].id;
                },
                isSelected: selectedKnowOption.value == options[index].id,
              ).animate().fadeIn(delay: (200 + index * 100).ms).slideX(begin: 0.1, end: 0),
            ),
            
            40.verticalSpace,
            
            BigButton(
              text: AppStrings.continueText,
              onPressed: selectedKnowOption.value != null &&
                      !ref.watch(registerControllerProvider).isLoading
                  ? () {
                      ref.read(registerControllerProvider.notifier).setKnowOption(selectedKnowOption.value!);
                    }
                  : null,
            ).animate().fadeIn(delay: 800.ms).scale(),
            
            40.verticalSpace,
          ],
        ),
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF00B4D8)),
              16.verticalSpace,
              const Text("جاري تحميل الخيارات...", style: TextStyle(fontFamily: 'SomarSans', fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/common/tayssir_commune_drop_down.dart';
import 'package:tayssir/common/tayssir_speciality_drop_down.dart';
import 'package:tayssir/common/tayssir_wilaya_drop_down.dart';
import 'package:tayssir/features/auth/presentation/register/state/register_controller.dart';
import 'package:tayssir/features/auth/presentation/register/views/specitlity.dart';
import 'package:tayssir/providers/divisions/division_model.dart';
import 'package:tayssir/providers/divisions/divisions.dart';
import 'package:tayssir/providers/user/commune.dart';
import 'package:tayssir/providers/user/wilaya.dart';
import 'package:tayssir/services/actions/snack_bar_service.dart';
import 'package:tayssir/utils/extensions/context.dart';

import '../../../../../common/core/app_scaffold.dart';
import '../../../../../constants/strings.dart';
import '../../../../../resources/colors/app_colors.dart';
import '../../../../../services/geo/geo_service.dart';
import '../../../../../utils/validators.dart';
import '../../login/custom_text_form_field.dart';
import '../../../../../common/tito_advice_widget.dart';

// final specialities = [
//   const Specitlity(name: "تقني رياضي", number: 1),
//   const Specitlity(name: "رياضيات", number: 2),
//   const Specitlity(name: "علوم تجريبية", number: 3),
//   const Specitlity(name: "تسيير و اقتصاد", number: 4),
//   const Specitlity(name: "لغات أجنبية", number: 5),
//   const Specitlity(name: "آداب و فلسفة", number: 6),
// ];

class PersonalInformationsView extends HookConsumerWidget {
  const PersonalInformationsView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerController = ref.watch(registerControllerProvider);
    final nameController = useTextEditingController(
      text: registerController.userData.fullName,
    );
    final ageController = useTextEditingController();
    final phoneController = useTextEditingController();
    final wilayas = ref.watch(wilayasProvider).requireValue;
    final wilaya = useState<Wilaya>(wilayas.first);
    final communes =
        ref.watch(communesProvider(wilaya.value.number)).asData?.value ?? [];
    final commune = useState<Commune?>(null);
    final speciality = useState<DivisionModel?>(null);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final canSubmit = useState(false);

    void checkCanSubmit() {
      if (nameController.text.isNotEmpty &&
          ageController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          commune.value != null &&
          speciality.value != null) {
        canSubmit.value = true;
      } else {
        canSubmit.value = false;
      }
    }

    commune.addListener(() {
      checkCanSubmit();
    });
    speciality.addListener(() {
      checkCanSubmit();
    });

    return AppScaffold(
      paddingB: 0,
      body: Form(
        key: formKey,
        onChanged: checkCanSubmit,
        child: SliverScrollingWidget(
          children: [
            const TitoAdviceWidget(
              text: AppStrings.enterPersonalInfo,
            ),
            20.verticalSpace,
            CustomTextFormField(
              controller: nameController,
              labelText: AppStrings.name,
              suffix: const Icon(Icons.person, color: AppColors.primaryColor),
            ),
            20.verticalSpace,
            CustomTextFormField(
              controller: ageController,
              labelText: AppStrings.age,
              keyboardType: TextInputType.phone,
              suffix: const Icon(Icons.cake, color: AppColors.primaryColor),
              validator: Validators.validateAge,
            ),
            20.verticalSpace,
            CustomTextFormField(
              controller: phoneController,
              labelText: AppStrings.phoneNumber,
              keyboardType: TextInputType.phone,
              suffix: const Icon(Icons.phone, color: AppColors.primaryColor),
              validator: Validators.phone,
            ),
            20.verticalSpace,
            // TODO:REFECTOR THIS
            TayssirWilayaDropDown(
                wilaya: wilaya, commune: commune, wilayas: wilayas),
            20.verticalSpace,
            TayssirCommuneDropDown(
                commune: commune, wilaya: wilaya, communes: communes),
            20.verticalSpace,
            TayssirSpecialityDropDown(
                division: speciality,
                items: ref.watch(divisionsProvider).requireValue),
            const Spacer(),
            if (context.isSmallDevice) 20.verticalSpace,
            BigButton(
              text: AppStrings.continueText,
              onPressed: registerController.isLoading || !canSubmit.value
                  ? null
                  : () {
                      if (nameController.text.length < 4) {
                        SnackBarService.showErrorSnackBar(
                            'يجب أن يكون الإسم أكبر من 3 أحرف',
                            context: context);
                        return;
                      }

                      if (formKey.currentState!.validate()) {
                        ref
                            .read(registerControllerProvider.notifier)
                            .setUserData(
                              nameController.text,
                              int.parse(ageController.text),
                              phoneController.text,
                              wilaya.value,
                              commune.value!,
                              speciality.value!.id,
                            );
                      }
                    },
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}

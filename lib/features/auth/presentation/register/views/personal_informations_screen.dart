import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/common/tayssir_commune_drop_down.dart';
import 'package:tayssir/common/tayssir_speciality_drop_down.dart';
import 'package:tayssir/common/tayssir_wilaya_drop_down.dart';
import 'package:tayssir/features/auth/presentation/register/state/register_controller.dart';
import 'package:tayssir/providers/divisions/division_model.dart';
import 'package:tayssir/providers/divisions/divisions.dart';
import 'package:tayssir/services/geo/geo_service.dart';
import 'package:tayssir/providers/user/commune.dart';
import 'package:tayssir/providers/user/wilaya.dart';
import 'package:tayssir/services/actions/snack_bar_service.dart';
import '../../../../../common/core/app_scaffold.dart';
import '../../../../../constants/strings.dart';
import '../../../../../utils/validators.dart';
import '../../login/custom_text_form_field.dart';
import '../../../../../common/tito_advice_widget.dart';
import '../../common/header_text.dart';

class PersonalInformationsView extends HookConsumerWidget {
  const PersonalInformationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerController = ref.watch(registerControllerProvider);
    final nameController = useTextEditingController(text: registerController.userData.fullName);
    final ageController = useTextEditingController();
    final phoneController = useTextEditingController();
    final wilayas = ref.watch(wilayasProvider).requireValue;
    final wilaya = useState<Wilaya>(wilayas.first);
    final communes = ref.watch(communesProvider(wilaya.value.number)).asData?.value ?? [];
    final commune = useState<Commune?>(null);
    final speciality = useState<DivisionModel?>(null);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final canSubmit = useState(false);

    void checkCanSubmit() {
      canSubmit.value = nameController.text.isNotEmpty &&
          ageController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          commune.value != null &&
          speciality.value != null;
    }

    return AppScaffold(
      paddingB: 0,
      body: Form(
        key: formKey,
        onChanged: checkCanSubmit,
        child: SliverScrollingWidget(
          children: [
            24.verticalSpace,
            const HeaderText(text: "المعومات الشخصية")
                .animate().fadeIn().slideY(begin: -0.1, end: 0),
            
            32.verticalSpace,
            
            const TitoAdviceWidget(
              text: "قم بإدخال المعلومات الشخصية الخاصة بك",
              isHorizontal: false,
            ).animate().fadeIn(delay: 100.ms).scale(curve: Curves.easeOutBack),
            
            40.verticalSpace,
            
            CustomTextFormField(
              controller: nameController,
              labelText: AppStrings.name,
              hintText: "الاسم الكامل",
              prefix: const Icon(Icons.person_outline_rounded),
            ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1, end: 0),
            
            20.verticalSpace,
            
            CustomTextFormField(
              controller: ageController,
              labelText: AppStrings.age,
              hintText: "مثلاً: 18",
              keyboardType: TextInputType.number,
              prefix: const Icon(Icons.cake_outlined),
              validator: Validators.validateAge,
            ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),
            
            20.verticalSpace,
            
            CustomTextFormField(
              controller: phoneController,
              labelText: AppStrings.phoneNumber,
              hintText: "06 / 07 / 05 ...",
              keyboardType: TextInputType.phone,
              prefix: const Icon(Icons.phone_outlined),
              validator: Validators.phone,
            ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),
            
            20.verticalSpace,
            
            TayssirWilayaDropDown(wilaya: wilaya, commune: commune, wilayas: wilayas)
                .animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),
            
            16.verticalSpace,
            
            TayssirCommuneDropDown(commune: commune, wilaya: wilaya, communes: communes)
                .animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, end: 0),
            
            16.verticalSpace,
            
            TayssirSpecialityDropDown(
              division: speciality,
              items: ref.watch(divisionsProvider).requireValue,
            ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1, end: 0),
            
            40.verticalSpace,
            
            BigButton(
              text: AppStrings.continueText,
              onPressed: registerController.isLoading || !canSubmit.value
                  ? null
                  : () {
                      if (nameController.text.length < 4) {
                        SnackBarService.showErrorSnackBar('يجب أن يكون الإسم أكبر من 3 أحرف', context: context);
                        return;
                      }
                      if (formKey.currentState!.validate()) {
                        ref.read(registerControllerProvider.notifier).setUserData(
                              nameController.text,
                              int.parse(ageController.text),
                              phoneController.text,
                              wilaya.value,
                              commune.value!,
                              speciality.value!.id,
                            );
                      }
                    },
            ).animate().fadeIn(delay: 800.ms).scale(),
            
            40.verticalSpace,
          ],
        ),
      ),
    );
  }
}

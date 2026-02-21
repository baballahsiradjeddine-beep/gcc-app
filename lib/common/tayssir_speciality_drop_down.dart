import 'package:flutter/material.dart';
import 'package:tayssir/common/forms/drop_down/taysir_drop_down.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/providers/divisions/division_model.dart';
import 'package:tayssir/resources/resources.dart';

class TayssirSpecialityDropDown extends StatelessWidget {
  const TayssirSpecialityDropDown({
    super.key,
    required this.division,
    required this.items,
  });

  final ValueNotifier<DivisionModel?> division;
  final List<DivisionModel> items;

  @override
  Widget build(BuildContext context) {
    return TayssirDropDown<DivisionModel>(
      selectedItem: division.value,
      items: items,
      onChanged: (value) {
        division.value = value;
      },
      hintText: AppStrings.speciality,
      iconPath: SVGs.icSpecitlity,
    );
  }
}

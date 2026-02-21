import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/forms/drop_down/taysir_drop_down.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/providers/user/commune.dart';
import 'package:tayssir/providers/user/wilaya.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/services/geo/geo_service.dart';

class TayssirWilayaDropDown extends ConsumerWidget {
  const TayssirWilayaDropDown({
    super.key,
    required this.wilaya,
    required this.wilayas,
    required this.commune,
  });

  final ValueNotifier<Wilaya> wilaya;
  final List<Wilaya> wilayas;
  final ValueNotifier<Commune?> commune;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TayssirDropDown<Wilaya>(
      selectedItem: wilaya.value,
      items: ref.watch(wilayasProvider).isLoading ? [] : wilayas,
      onChanged: (value) {
        if (value == wilaya.value) return;
        commune.value = null;
        wilaya.value = value!;
      },
      hintText: AppStrings.wilaya,
      iconPath: SVGs.icBuilding,
    );
  }
}

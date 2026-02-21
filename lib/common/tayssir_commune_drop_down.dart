import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/forms/drop_down/taysir_drop_down.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/providers/user/commune.dart';
import 'package:tayssir/providers/user/wilaya.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/services/geo/geo_service.dart';

class TayssirCommuneDropDown extends ConsumerWidget {
  const TayssirCommuneDropDown({
    super.key,
    required this.commune,
    required this.wilaya,
    required this.communes,
  });

  final ValueNotifier<Commune?> commune;
  final ValueNotifier<Wilaya> wilaya;
  final List<Commune> communes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TayssirDropDown<Commune>(
      selectedItem: commune.value,
      items: ref.watch(communesProvider(wilaya.value.number)).isLoading
          ? []
          : communes,
      onChanged: (value) {
        if (value == commune.value) return;
        commune.value = value;
      },
      hintText: AppStrings.dairaOrCommune,
      iconPath: SVGs.icCommune,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:tayssir/providers/user/wilaya_dropdown_item.dart';

class Specitlity extends Equatable implements TaysirDropdownItem {
  @override
  final String name;

  @override
  final int number;

  const Specitlity({required this.name, required this.number});

  @override
  List<Object> get props => [name, number];
}

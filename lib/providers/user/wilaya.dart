import 'package:equatable/equatable.dart';
import 'package:tayssir/providers/user/wilaya_dropdown_item.dart';

class Wilaya extends Equatable implements TaysirDropdownItem {
  @override
  final String name;

  @override
  final int number;

  const Wilaya({
    required this.name,
    required this.number,
  });

  // empty
  factory Wilaya.empty() {
    return const Wilaya(
      name: '',
      number: 0,
    );
  }

  // from map
  factory Wilaya.fromMap(Map<String, dynamic> map) {
    return Wilaya(
      name: map['arabic_name'] as String,
      number: map['id'] as int,
    );
  }

  /// to map
  Map<String, dynamic> toMap() {
    return {
      'arabic_name': name,
      'id': number,
    };
  }

  @override
  List<Object?> get props => [name, number];
}

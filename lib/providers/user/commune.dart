import 'package:equatable/equatable.dart';
import 'package:tayssir/providers/user/wilaya_dropdown_item.dart';

class Commune extends Equatable implements TaysirDropdownItem {
  @override
  final String name;

  @override
  final int number;

  const Commune({
    required this.name,
    required this.number,
  });

  //empty
  factory Commune.empty() {
    return const Commune(
      name: '',
      number: 0,
    );
  }

  factory Commune.fromMap(Map<String, dynamic> map) {
    return Commune(
      name: map['arabic_name'] as String,
      number: map['id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'arabic_name': name,
      'id': number,
    };
  }

  @override
  List<Object?> get props => [name, number];
}

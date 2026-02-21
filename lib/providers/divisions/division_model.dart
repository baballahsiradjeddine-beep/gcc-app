// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:equatable/equatable.dart';

import '../user/wilaya_dropdown_item.dart';



class DivisionModel extends Equatable implements TaysirDropdownItem {
  final int id;
  @override
  final String name;

  const DivisionModel({
    required this.id,
    required this.name,
  });

  @override
  int get number => id; 

  DivisionModel copyWith({
    int? id,
    String? name,
  }) {
    return DivisionModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory DivisionModel.fromMap(Map<String, dynamic> map) {
    return DivisionModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DivisionModel.fromJson(String source) =>
      DivisionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name];
}

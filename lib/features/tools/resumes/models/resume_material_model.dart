import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ResumeMaterialModel extends Equatable {
  final int id;
  final String name;
  final List<Color> colors;

  const ResumeMaterialModel({
    required this.id,
    required this.name,
    required this.colors,
  });

  factory ResumeMaterialModel.fromJson(Map<String, dynamic> json) {
    return ResumeMaterialModel(
      id: json['id'] as int,
      name: json['name'] as String,
      colors: (json['colors'] as List<dynamic>?)
              ?.map((e) => Color(
                  int.parse((e as String).replaceFirst('#', ''), radix: 16) +
                      0xFF000000))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colors': colors.map((e) => e.value).toList(),
    };
  }

  @override
  List<Object?> get props => [id, name, colors];
}

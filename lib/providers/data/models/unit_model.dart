// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:ui';

import 'package:equatable/equatable.dart';

enum UnitVisibility { available, premium }

class UnitModel extends Equatable {
  final int id;
  final String title;
  final int materialId;
  final double progress;
  final TextDirection direction;
  final String? description;
  final String? image;
  final UnitVisibility visibility;
  const UnitModel({
    required this.id,
    required this.title,
    required this.materialId,
    required this.progress,
    this.direction = TextDirection.rtl,
    this.description,
    this.visibility = UnitVisibility.available,
    this.image,
  });

  bool get isCompleted => progress > 50.0;

  UnitModel copyWith({
    int? id,
    String? title,
    int? materialId,
    double? progress,
    TextDirection? direction,
    String? description,
    String? image,
  }) {
    return UnitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      materialId: materialId ?? this.materialId,
      image: image ?? this.image,
      progress: progress ?? this.progress,
      direction: direction ?? this.direction,
      description: description ?? this.description,
      visibility: visibility,
    );
  }

  UnitModel setProgress(double progress) {
    return copyWith(progress: progress);
  }

  factory UnitModel.fromMap(Map<String, dynamic> map) {
    return UnitModel(
      id: map['id'] as int,
      title: map['name'] as String,
      materialId: map['material_id'] as int,
      progress: map['progress'] == null
          ? 20.0
          : map['progress'] is int
              ? (map['progress'] as int).toDouble()
              : map['progress'] as double,
      direction:
          map['direction'] == 'RTL' ? TextDirection.rtl : TextDirection.ltr,
      description: map['description'] as String?,
      image: map['image'] as String?,
      visibility: map['visibility'] == 'premium'
          ? UnitVisibility.premium
          : UnitVisibility.available,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        materialId,
        progress,
        direction,
        description,
        image,
        visibility
      ];

  @override
  bool get stringify => true;
}

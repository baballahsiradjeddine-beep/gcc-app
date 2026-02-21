import 'package:equatable/equatable.dart';

class ResumeUnitModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final int materialId;
  final String pdf;

  const ResumeUnitModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pdf,
    required this.materialId,
  });

  factory ResumeUnitModel.fromJson(Map<String, dynamic> json) {
    return ResumeUnitModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      pdf: json['pdf'] as String? ?? '',
      materialId: json['materialId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pdf': pdf,
      'materialId': materialId,
    };
  }

  @override
  List<Object?> get props => [id, name, pdf, description, materialId];
}

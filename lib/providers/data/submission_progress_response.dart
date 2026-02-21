import 'package:tayssir/providers/data/progress_model.dart';

class SubmissionProgressResponse {
  final ProgressModel material;
  final ProgressModel unit;
  final ProgressModel chapter;

  SubmissionProgressResponse({
    required this.material,
    required this.unit,
    required this.chapter,
  });

  SubmissionProgressResponse copyWith({
    ProgressModel? material,
    ProgressModel? unit,
    ProgressModel? chapter,
  }) {
    return SubmissionProgressResponse(
      material: material ?? this.material,
      unit: unit ?? this.unit,
      chapter: chapter ?? this.chapter,
    );
  }

  // from map
  factory SubmissionProgressResponse.fromMap(Map<String, dynamic> map) {
    return SubmissionProgressResponse(
      material: ProgressModel.fromMap(map['material']),
      unit: ProgressModel.fromMap(map['unit']),
      chapter: ProgressModel.fromMap(map['chapter']),
    );
  }
}

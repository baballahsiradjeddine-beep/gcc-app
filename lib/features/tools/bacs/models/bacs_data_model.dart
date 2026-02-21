import 'package:tayssir/features/tools/bacs/models/bac_subject.dart';
import 'package:tayssir/features/tools/bacs/models/bac_topic.dart';

class BacsDataModel {
  final List<BacTopic> bacTopics;
  final List<BacSubject> bacSubjects;

  BacsDataModel({
    required this.bacTopics,
    required this.bacSubjects,
  });

  factory BacsDataModel.fromJson(Map<String, dynamic> json) {
    return BacsDataModel(
      bacTopics: (json['materials'] as List<dynamic>)
          .map((item) => BacTopic.fromJson(item as Map<String, dynamic>))
          .toList(),
      bacSubjects: (json['units'] as List<dynamic>)
          .map((item) => BacSubject.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

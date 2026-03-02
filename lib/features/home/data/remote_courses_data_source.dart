import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/dio/dio.dart';
import '../../../constants/end_points.dart';

final remoteDataSourceProvider = Provider<RemoteCoursesDataSource>((ref) {
  return RemoteCoursesDataSource(dioClient: ref.watch(dioClientProvider));
});

class RemoteCoursesDataSource {
  final DioClient _dioClient;

  RemoteCoursesDataSource({required dioClient}) : _dioClient = dioClient;

  Future<Response> getCourses({int? divisionId}) async {
    final response = await _dioClient.get(
      EndPoints.getData,
      queryParameters: divisionId != null ? {'division_id': divisionId} : null,
    );
    return response;
  }

  Future<Response> submitAnswers(Map<String, dynamic> data) async {
    final response = await _dioClient.post(
      EndPoints.submitAnswers,
      data: data,
    );
    return response;
  }

  Future<Response> reportExercise(ReportExoDto reportExoDto) async {
    final response = await _dioClient.post(
      EndPoints.reportExercise,
      data: reportExoDto.toMap(),
    );
    return response;
  }
}

class ReportExoDto {
  final int exerciseId;
  final String? reason;

  ReportExoDto({
    required this.exerciseId,
    this.reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'question_id': exerciseId,
      'description': reason ?? 'this exercise has issues',
    };
  }
}

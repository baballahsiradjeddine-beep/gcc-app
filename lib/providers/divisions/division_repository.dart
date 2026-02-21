import 'package:tayssir/providers/divisions/division_data_source.dart';
import 'package:tayssir/providers/divisions/division_model.dart';

class DivisionRepository {
  final DivisionDataSource divisionDataSource;

  DivisionRepository({required this.divisionDataSource});

  Future<List<DivisionModel>> getDivisions() async {
    final response = await divisionDataSource.getDivisions();
    final divisions = response.data['data'] as List;
    return divisions.map((e) => DivisionModel.fromMap(e)).toList();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/dio/dio.dart';
import 'package:tayssir/providers/divisions/division_data_source.dart';
import 'package:tayssir/providers/divisions/division_repository.dart';

import 'division_model.dart';

final divisionsProvider = FutureProvider<List<DivisionModel>>((ref) async {
  final divisionRepository = ref.watch(divisionRepositoryProvider);
  final items = await divisionRepository.getDivisions();
  return items;
});

final divisionRepositoryProvider = Provider<DivisionRepository>((ref) {
  final divisionDataSource = ref.watch(remoteDivisionDataSourceProvider);
  return DivisionRepository(divisionDataSource: divisionDataSource);
});

final remoteDivisionDataSourceProvider = Provider<DivisionDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DivisionDataSource(dioClient: dioClient);
});

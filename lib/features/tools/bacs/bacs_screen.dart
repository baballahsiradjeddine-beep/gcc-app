import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:tayssir/features/tools/bacs/bacs_data_view.dart';
import 'package:tayssir/features/tools/bacs/bacs_loading_view.dart';
import 'package:tayssir/features/tools/bacs/models/bacs_data_model.dart';
import 'package:tayssir/features/tools/common/data/tool_repository.dart';

final bacDataProvider = FutureProvider<BacsDataModel>((ref) async {
  final res = await ref.watch(toolRepositoryProvider).getBacsData();
  return res;
});

class BacsScreen extends HookConsumerWidget {
  const BacsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bacDataAsync = ref.watch(bacDataProvider);

    return bacDataAsync.when(
      loading: () => const BacsLoadingView(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            SizedBox(height: 16.h),
            Text(
              'حدث خطأ في تحميل البيانات',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              error.toString(),
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      data: (data) => BacsDataView(data: data),
    );
  }
}

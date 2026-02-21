// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:shimmer/shimmer.dart';

// class AsyncValueWidget<T> extends StatelessWidget {
//   const AsyncValueWidget({super.key, required this.value, required this.data});

//   final AsyncValue<T> value;
//   final Widget Function(T) data;

//   @override
//   Widget build(BuildContext context) {
//     return value.when(
//       data: data,
//       error: (error, stackTrace) => Center(child: Text(stackTrace.toString())),
//       loading: () => SizedBox(
//         height: 7000.h,
//         child: Shimmer.fromColors(
//             enabled: true,
//             baseColor: Colors.grey.shade300,
//             highlightColor: Colors.red,
//             child: ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   return Container(
//                     height: 100,
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   );
//                 })),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/core/custom_app_bar.dart';
import 'package:tayssir/features/home/presentation/home_screen.dart';
import 'package:tayssir/features/home/presentation/subscribe_section.dart';

class EmptyContentWidget extends StatelessWidget {
  const EmptyContentWidget({
    super.key,
    this.message = 'لا يوجد محتوى',
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        paddingB: 0,
        paddingX: 0,
        appBar: const CustomAppBar(),
        body: Column(
          children: [
            const SubscribeSection(),
            Expanded(
              child: Center(
                child: Text(message,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ));
  }
}

//  return Container(
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     child: Row(
//                       children: [
//                         const CircularProgressWidget(
//                           percentage: 20,
//                           color: AppColors.primaryColor,
//                           child: Icon(Icons.play_arrow),
//                         ),
//                         16.horizontalSpace,
//                         Expanded(
//                             child: PushableButton(
//                           height: 50.h,
//                           elevation: 4,
//                           onPressed: () {
//                             // ref.read(currentUnitIdProvider.notifier).state =
//                             //     int.parse(units[index].id.toString());

//                             context.pushNamed(AppRoutes.chapters.name,
//                                 pathParameters: {
//                                   'unitId': units[index].id.toString(),
//                                 });
//                           },
//                           hslColor: HSLColor.fromColor(
//                             isCurrent ? AppColors.primaryColor : Colors.white,
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 Text(units[index].title,
//                                     textAlign: TextAlign.start,
//                                     style: TextStyle(
//                                         color: isCurrent
//                                             ? Colors.white
//                                             : Colors.black,
//                                         fontSize: 20.sp,
//                                         fontWeight: FontWeight.bold)),
//                                 if (isCurrent) ...[
//                                   const Spacer(),
//                                   const Icon(
//                                     Icons.check,
//                                     color: Colors.white,
//                                   )
//                                 ]
//                               ],
//                             ),
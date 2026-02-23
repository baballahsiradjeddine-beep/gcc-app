import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/home/presentation/view_style.dart';

import 'change_view_widget.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.viewStyle,
    this.title = 'المواد المتاحة',
  });

  final ValueNotifier<ViewStyle> viewStyle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // add :
        Text('$title :',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        ChangeViewWidget(viewStyle: viewStyle),
      ],
    );
  }
}

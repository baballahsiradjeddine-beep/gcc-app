import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliverScrollingWidget extends StatelessWidget {
  const SliverScrollingWidget({super.key, required this.children, this.header});
  final List<Widget> children;
  final Widget? header;
  @override
  Widget build(BuildContext context) {
    //TODO add app scaffold in here and add form field also
    return CustomScrollView(
      slivers: [
        if (header != null)
          SliverAppBar(
            pinned: true,
            floating: false,
            snap: false,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            expandedHeight: 100.h,
            flexibleSpace: FlexibleSpaceBar(
              background: header,
            ),
          ),
        SliverFillRemaining(
          hasScrollBody: false,
          // fillOverscroll: false,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

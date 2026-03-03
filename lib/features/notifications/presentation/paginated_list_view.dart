import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/notifications/presentation/visible_trigger.dart';

class PaginatedListView<T> extends StatelessWidget {
  final List<T> data;
  final bool canLoadMore;
  final bool isFetchingMore;
  final VoidCallback onLoadMore;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;

  const PaginatedListView({
    super.key,
    required this.data,
    required this.canLoadMore,
    required this.isFetchingMore,
    required this.onLoadMore,
    required this.itemBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: padding ?? EdgeInsets.zero,
      itemCount: data.length + (canLoadMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == data.length) {
          return canLoadMore
              ? isFetchingMore
                  ? const Center(child: CircularProgressIndicator())
                  : VisibleTrigger(
                      onVisible: onLoadMore,
                      child: Center(
                        child: Text(
                          '.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
              : const SizedBox.shrink();
        }

        final item = data[index];
        return itemBuilder(context, item, index);
      },
    );
  }
}

import 'package:flutter/material.dart';

class HomeListView<T> extends StatelessWidget {
  const HomeListView({
    super.key,
    required this.items,
    required this.itemBuilder,
  });

  final List<T> items;
  final Widget Function(T) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return itemBuilder(items[index]);
      },
    );
  }
}

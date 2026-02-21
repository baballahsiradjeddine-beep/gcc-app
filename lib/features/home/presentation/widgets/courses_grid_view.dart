import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class HomeGridView<T> extends StatelessWidget {
  const HomeGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
  });

  final List<T> items;

  final Widget Function(T) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridList(
      horizontalGridSpacing: 20,
      verticalGridSpacing: 10,
      horizontalGridMargin: 0,
      verticalGridMargin: 10,
      minItemWidth: 200,
      minItemsPerRow: 2,
      maxItemsPerRow: 3,
      listViewBuilderOptions: ListViewBuilderOptions(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.zero),
      children: [
        ...items.map(
          itemBuilder,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SearchHeaderDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => SizedBox.expand(
    child: Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: child,
    ),
  );

  @override
  bool shouldRebuild(SearchHeaderDelegate oldDelegate) =>
      height != oldDelegate.height || child != oldDelegate.child;
}

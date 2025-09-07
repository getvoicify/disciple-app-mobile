import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:disciple/app/utils/extension.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    this.minHeight = kToolbarHeight,
    this.maxHeight = kToolbarHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final bool isPinned = shrinkOffset.ceil() == maxHeight.ceil();

    return SizedBox.expand(
      child: Container(
        color: isPinned ? context.scaffoldBackgroundColor : Colors.transparent,
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) =>
      maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
}

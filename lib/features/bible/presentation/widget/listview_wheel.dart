import 'package:disciple/app/common/app_colors.dart';
import 'package:flutter/material.dart';

class BuildListviewWheel extends StatefulWidget {
  final int itemCount;
  final int selectedIndex;
  final String Function(int) itemBuilder;
  final ValueChanged<int> onSelected;
  final PageStorageKey? pageStorageKey;
  final double? itemExtent;

  const BuildListviewWheel({
    super.key,
    required this.itemCount,
    required this.selectedIndex,
    required this.itemBuilder,
    required this.onSelected,
    this.pageStorageKey,
    this.itemExtent = 48.0,
  });

  @override
  State<BuildListviewWheel> createState() => _BuildListviewWheelState();
}

class _BuildListviewWheelState extends State<BuildListviewWheel> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedIndex > 0) {
        _scrollToIndex(widget.selectedIndex);
      }
    });
  }

  @override
  void didUpdateWidget(covariant BuildListviewWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _scrollToIndex(widget.selectedIndex);
    }
  }

  void _scrollToIndex(int index) {
    if (_controller.hasClients) {
      // _controller.animateTo(
      //   index * (widget.itemExtent ?? 48.0),
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.easeOut,
      // );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Flexible(
    child: ListView.builder(
      key: widget.pageStorageKey,
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.itemCount,
      itemExtent: widget.itemExtent,
      itemBuilder: (context, index) {
        final bool isSelected = widget.selectedIndex == index;
        return TextButton(
          onPressed: () => widget.onSelected(index),
          style: TextButton.styleFrom(
            foregroundColor: isSelected ? AppColors.purple : AppColors.grey100,
          ),
          child: Text(
            widget.itemBuilder(index),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    ),
  );
}

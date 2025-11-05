import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildListviewWheel extends StatelessWidget {
  final int itemCount;
  final int selectedIndex;
  final String Function(int) itemBuilder;
  final ValueChanged<int> onSelected;
  final ScrollController controller;

  const BuildListviewWheel({
    super.key,
    required this.itemCount,
    required this.selectedIndex,
    required this.itemBuilder,
    required this.onSelected,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) => Flexible(
    child: ListWheelScrollView.useDelegate(
      controller: controller,
      physics: const FixedExtentScrollPhysics(),
      useMagnifier: true,
      magnification: 1.15,
      onSelectedItemChanged: onSelected,
      itemExtent: 50.h,
      squeeze: 1.1,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final bool isSelected = selectedIndex == index;
          return AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontSize: isSelected ? 14.sp : 12.sp,
              color: isSelected ? AppColors.purple : AppColors.grey100,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              fontFamily: AppFonts.literata,
            ),
            child: Center(child: Text(itemBuilder(index))),
          );
        },
      ),
    ),
  );
}

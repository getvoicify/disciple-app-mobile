import 'package:disciple/app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
  const DecoratedTabBar({super.key, required this.tabBar, this.decoration});

  final TabBar tabBar;
  final BoxDecoration? decoration;

  @override
  Size get preferredSize => tabBar.preferredSize * 1.5;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration:
                decoration ??
                BoxDecoration(
                  color: AppColors.purple50,
                  borderRadius: BorderRadius.circular(7.r),
                ),
          ),
        ),
        tabBar,
      ],
    );
  }
}

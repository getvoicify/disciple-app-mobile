import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildDropdownWidget extends StatelessWidget {
  const BuildDropdownWidget({
    super.key,
    required this.title,
    this.dropdown = true,
    this.padding,
    this.color,
    this.borderColor,
    this.textColor,
  });

  final String title;
  final bool dropdown;
  final EdgeInsets? padding;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color ?? AppColors.grey50,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: borderColor ?? AppColors.grey200, width: 1.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              title,
              style: context.headlineLarge?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
          if (dropdown) ...[
            SizedBox(width: 8.w),
            ImageWidget(imageUrl: AppImage.arrowDownIcon),
          ],
        ],
      ),
    );
  }
}

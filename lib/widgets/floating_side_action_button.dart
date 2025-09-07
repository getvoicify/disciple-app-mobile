import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatingSideButtonWidget extends StatelessWidget {
  const FloatingSideButtonWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.only(
          right: 24.w,
          top: 13.h,
          left: 24.w,
          bottom: 13.h,
        ),
        margin: EdgeInsets.only(bottom: 70.h),
        decoration: BoxDecoration(
          color: AppColors.purple,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(24.r)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageWidget(imageUrl: AppImage.addIcon),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                title,
                style: context.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

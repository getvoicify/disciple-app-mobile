import 'package:disciple/app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildTileSkeleton extends StatelessWidget {
  const BuildTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: AppColors.grey200, width: .5.w),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Title placeholder
            Expanded(
              child: Container(
                height: 16.h,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Date placeholder
            Container(
              height: 12.h,
              width: 60.w,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // Content line 1
        Container(
          height: 14.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 6.h),
        // Content line 2
        Container(
          height: 14.h,
          width: 0.8.sw,
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 6.h),
        // Content line 3
        Container(
          height: 14.h,
          width: 0.6.sw,
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ChurchListItemSkeleton extends StatelessWidget {
  const ChurchListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: AppColors.grey750,
    highlightColor: AppColors.grey50,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey750, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey750.withValues(alpha: .05),
            blurRadius: .5.r,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image placeholder
          Container(
            height: 76.h,
            width: 109.w,
            decoration: BoxDecoration(
              color: AppColors.grey750,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(width: 16.w),

          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + icon row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: AppColors.grey750,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Container(
                      height: 16.h,
                      width: 16.h,
                      decoration: BoxDecoration(
                        color: AppColors.grey750,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // City
                Container(
                  height: 14.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: AppColors.grey750,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 6.h),

                // Address
                Container(
                  height: 12.h,
                  width: 140.w,
                  decoration: BoxDecoration(
                    color: AppColors.grey750,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

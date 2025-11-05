import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DevotionalSkeletonList extends StatelessWidget {
  const DevotionalSkeletonList({super.key});

  @override
  Widget build(BuildContext context) => ListView.separated(
    itemCount: 6, // number of skeleton items
    separatorBuilder: (_, _) => SizedBox(height: 20.h),
    itemBuilder: (_, _) => Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          // Thumbnail skeleton
          Container(
            height: 126.h,
            width: 126.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(width: 16.w),

          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonLine(width: 180.w, height: 16.h),
                SizedBox(height: 8.h),
                _buildSkeletonLine(width: 140.w, height: 14.h),
                SizedBox(height: 6.h),
                _buildSkeletonLine(width: 120.w, height: 12.h),
                SizedBox(height: 10.h),
                _buildSkeletonLine(width: double.infinity, height: 1.h),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _buildCircleSkeleton(size: 24.w),
                    SizedBox(width: 16.w),
                    _buildCircleSkeleton(size: 24.w),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildSkeletonLine({required double width, required double height}) =>
      Container(width: width, height: height, color: Colors.white);

  Widget _buildCircleSkeleton({required double size}) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
    ),
  );
}

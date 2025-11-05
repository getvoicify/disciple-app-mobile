import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class PostTileSkeleton extends StatelessWidget {
  const PostTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) => ListView.separated(
    itemCount: 20,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    separatorBuilder: (context, index) => SizedBox(height: 26.h),
    itemBuilder: (context, index) => Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pinned label skeleton
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCircle(size: 16.w),
              SizedBox(width: 8.w),
              _buildLine(width: 60.w, height: 12.h),
            ],
          ),
          SizedBox(height: 8.h),

          // Image skeleton
          Container(
            height: 251.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(height: 10.h),

          // Likes row skeleton
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCircle(size: 20.w),
              SizedBox(width: 8.w),
              _buildLine(width: 40.w, height: 12.h),
            ],
          ),
          SizedBox(height: 10.h),

          // Content text skeleton (multiple lines)
          _buildLine(width: double.infinity, height: 12.h),
          SizedBox(height: 6.h),
          _buildLine(width: double.infinity, height: 12.h),
          SizedBox(height: 6.h),
          _buildLine(width: 180.w, height: 12.h),
          SizedBox(height: 8.h),

          // Timestamp skeleton
          _buildLine(width: 80.w, height: 10.h),
        ],
      ),
    ),
  );

  Widget _buildLine({required double width, required double height}) =>
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
      );

  Widget _buildCircle({required double size}) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
    ),
  );
}

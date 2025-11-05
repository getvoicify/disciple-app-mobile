import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/community/data/model/church.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/widgets/image_widget.dart';

class ChurchListItem extends StatelessWidget {
  const ChurchListItem({super.key, required this.church, required this.onTap});

  final Church church;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.white,
        border: Border.all(color: AppColors.grey750, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: .1),
            blurRadius: .5.r,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: ImageWidget(
              height: 76.h,
              width: 109.w,
              fit: BoxFit.cover,
              imageUrl: church.logoUrl ?? '',
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        church.name ?? '',
                        style: context.headlineLarge?.copyWith(fontSize: 16.sp),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    const ImageWidget(imageUrl: AppImage.pinAngleFillIcon),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  church.address?.city ?? '',
                  style: context.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.grey700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  church.getAddress,
                  style: context.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.grey500,
                    fontWeight: FontWeight.w500,
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

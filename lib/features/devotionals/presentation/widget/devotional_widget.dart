import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/devotionals/data/model/devotional.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DevotionalWidget extends StatelessWidget {
  const DevotionalWidget({super.key, required this.devotional});

  final Devotional devotional;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        height: 126.h,
        width: 126.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.red50,
        ),
      ),
      SizedBox(width: 16.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Potter’s Heart',
              style: context.headlineLarge?.copyWith(fontSize: 16.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text('by Potter’sVille Church', style: context.bodyMedium),
            SizedBox(height: 2.h),
            Text(
              'Author: Pastor kayode Oguta',
              style: context.bodyMedium?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            const Divider(),
            SizedBox(height: 8.h),
            Row(
              children: [
                const ImageWidget(imageUrl: AppImage.likeIcon3),
                SizedBox(width: 16.w),
                const ImageWidget(imageUrl: AppImage.shareIcon2),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

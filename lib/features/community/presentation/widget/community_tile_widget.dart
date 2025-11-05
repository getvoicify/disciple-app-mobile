import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommuityTIleWidget extends StatelessWidget {
  const CommuityTIleWidget({super.key, this.isJoined = false});

  final bool isJoined;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      color: AppColors.white,
      border: Border.all(color: AppColors.grey750, width: .5.w),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: .1),
          blurRadius: 1,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          height: 77.h,
          width: 73.w,
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Daniel Generation',
                      style: context.headlineLarge?.copyWith(fontSize: 16.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isJoined) ...[
                    SizedBox(width: 8.w),
                    const ImageWidget(imageUrl: AppImage.checkIcon),
                    SizedBox(width: 4.w),
                    Text(
                      'Joined',
                      style: context.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                'Potter’s Ville Church',
                style: context.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.grey700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5.h),
              const Divider(),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tuesdays 8pm',
                      style: context.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  const ImageWidget(imageUrl: AppImage.peopleIcon),
                  SizedBox(width: 4.w),
                  Text(
                    '150',
                    style: context.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

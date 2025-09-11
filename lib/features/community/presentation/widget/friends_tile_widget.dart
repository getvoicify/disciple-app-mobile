import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FriendsTileWidget extends StatelessWidget {
  const FriendsTileWidget({super.key});

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
        CircleAvatar(radius: 30.r),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: 'Becky',
                  style: context.headlineMedium?.copyWith(fontSize: 16.sp),
                  children: [
                    TextSpan(
                      text: ' Just now',
                      style: context.bodyMedium?.copyWith(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 9.h),
              Text(
                'Thanks for being amazing!',
                style: context.bodyMedium?.copyWith(fontSize: 14.sp),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

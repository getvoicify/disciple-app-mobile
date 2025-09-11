import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildFriendsTileWidget extends StatelessWidget {
  const BuildFriendsTileWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: AppColors.grey200, width: .5.w),
    ),
    child: Row(
      children: [
        const CircleAvatar(),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            'Becky',
            style: context.headlineMedium?.copyWith(fontSize: 16.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(width: 16.w),
        const ImageWidget(imageUrl: AppImage.userFriendsIcon),
        SizedBox(width: 4.w),
        Text(
          'Friends',
          style: context.headlineMedium?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.green,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
        ),
      ],
    ),
  );
}

import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadImageSection extends StatelessWidget {
  const UploadImageSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.grey200, width: 1.w),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Column(
      children: [
        const ImageWidget(imageUrl: AppImage.uploadIcon),
        SizedBox(height: 8.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: AppString.clickToUpload,
            style: context.headlineMedium?.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.purple,
            ),
            children: [
              TextSpan(
                text: AppString.dragAndDrop,
                style: context.titleSmall?.copyWith(fontSize: 10.sp),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

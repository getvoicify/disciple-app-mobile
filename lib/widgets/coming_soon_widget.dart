import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComingSoonWidget extends StatelessWidget {
  const ComingSoonWidget({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    physics: const NeverScrollableScrollPhysics(),
    child: Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageWidget(
              imageUrl: AppImage.community,
              height: 96.h,
              width: 96.w,
            ),
            SizedBox(height: 16.h),
            Text(
              'Coming Soon',
              style: context.headlineLarge?.copyWith(
                fontSize: 28.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'This feature is not available yet. We\'re working on it and it will be released in a future update.',
              style: context.headlineSmall?.copyWith(
                fontSize: 15.sp,
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

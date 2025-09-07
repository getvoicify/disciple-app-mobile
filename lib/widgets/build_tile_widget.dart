import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildTileWidget extends StatelessWidget {
  const BuildTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey200, width: .5.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Title',
                  style: context.headlineMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  'Yesterday',
                  style: context.bodyLarge?.copyWith(
                    fontSize: 10.sp,
                    fontStyle: FontStyle.italic,
                    color: AppColors.grey500,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Dorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus.',
            style: context.headlineMedium?.copyWith(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

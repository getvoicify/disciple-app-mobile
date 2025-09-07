import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderTileWidget extends StatelessWidget {
  const ReminderTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.primaries[0].withValues(alpha: .2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageWidget(imageUrl: AppImage.clockIcon),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  '6:00 AM',
                  style: context.bodyMedium?.copyWith(fontSize: 12.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Bible Reading',
            style: context.headlineMedium?.copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}

import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderTileWidget extends StatelessWidget {
  const ReminderTileWidget({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.color,
  });

  final Color? color;
  final String? title, date, time;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 16.h),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const ImageWidget(imageUrl: AppImage.clockIcon),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                date ?? '',
                style: context.bodyMedium?.copyWith(fontSize: 12.sp),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              time ?? '',
              style: context.bodyMedium?.copyWith(fontSize: 12.sp),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          title ?? '',
          style: context.headlineMedium?.copyWith(fontSize: 16.sp),
        ),
      ],
    ),
  );
}

<<<<<<< HEAD
=======
import 'package:disciple/app/common/app_colors.dart';
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderTileWidget extends StatelessWidget {
<<<<<<< HEAD
  const ReminderTileWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(
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
            const ImageWidget(imageUrl: AppImage.clockIcon),
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
=======
  const ReminderTileWidget({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.color,
    this.isNotActive = false,
    this.onTap,
  });

  final Color? color;
  final String? title, date, time;
  final bool isNotActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isNotActive ? AppColors.grey750 : color,
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
            style: context.headlineLarge?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
    ),
  );
}

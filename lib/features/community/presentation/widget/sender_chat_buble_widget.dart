import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SenderChatBubleWidget extends StatelessWidget {
  const SenderChatBubleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.width * .5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      'You',
                      style: context.bodyMedium?.copyWith(fontSize: 12.sp),
                    ),
                  ),
                  Text(
                    '10:16am',
                    style: context.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: context.width,
                child: Card(
                  color: AppColors.purple3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      bottomLeft: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 14.w,
                      top: 10.h,
                      right: 28.w,
                      bottom: 10.h, // Extra padding at bottom for the time
                    ),
                    child: Text(
                      'This is my message.',
                      style: context.bodyMedium?.copyWith(fontSize: 16.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

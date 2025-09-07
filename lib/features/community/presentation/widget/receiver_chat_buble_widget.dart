import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceiverChatBubleWidget extends StatelessWidget {
  const ReceiverChatBubleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(),
        SizedBox(width: 12.w),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: context.width * .6,
                child: Card(
                  color: AppColors.grey750,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.r),
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
                      'Thanks everyone! Almost there.',
                      style: context.bodyMedium?.copyWith(fontSize: 16.sp),
                    ),
                  ),
                ),
              ),
              Text(
                '10:16am',
                style: context.bodyMedium?.copyWith(fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageEntryWidget extends StatelessWidget {
  const MessageEntryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300, width: .5.w),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: EditTextFieldWidget(
                  titleWidget: SizedBox.shrink(),
                  fillColor: Colors.transparent,
                  maxLines: 2,
                  label: 'Message',
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ImageWidget(imageUrl: AppImage.send, fit: BoxFit.none),
              ),
            ],
          ),

          SizedBox(height: 12.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageWidget(imageUrl: AppImage.add2),
              SizedBox(width: 13.w),
              ImageWidget(imageUrl: AppImage.emoji),
            ],
          ),
        ],
      ),
    );
  }
}

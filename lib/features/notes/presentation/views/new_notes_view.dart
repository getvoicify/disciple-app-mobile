import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/drop_down_widget.dart'
    show BuildDropdownWidget;
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/elevated_button_widget.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Note'),
        leading: ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          children: [
            EditTextFieldWidget(title: 'Title'),
            SizedBox(height: 14.h),
            Text(
              'Add Scripture',
              style: context.headlineLarge?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                border: BoxBorder.all(color: AppColors.grey200, width: 1.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildDropdownWidget(title: 'KJV'),
                  SizedBox(height: 16.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildDropdownWidget(title: 'Book'),
                      BuildDropdownWidget(title: 'Chapter'),
                      BuildDropdownWidget(title: 'Verse'),
                      BuildDropdownWidget(
                        title: 'Add',
                        dropdown: false,
                        color: AppColors.purple,
                        borderColor: AppColors.purple,
                        textColor: AppColors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 4.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            EditTextFieldWidget(title: 'Note detail', maxLines: 20),
            SizedBox(height: 14.h),

            RichText(
              text: TextSpan(
                text: 'Add Images',
                style: context.headlineLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: ' (optional)',
                    style: context.headlineLarge?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                border: BoxBorder.all(color: AppColors.grey200, width: 1.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageWidget(imageUrl: AppImage.uploadIcon),
                  SizedBox(height: 8.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Click to upload',
                      style: context.headlineMedium?.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.purple,
                      ),
                      children: [
                        TextSpan(
                          text:
                              ' or drag and drop\nSVG, PNG, JPG or GIF (max. 800x400px)',
                          style: context.titleSmall?.copyWith(fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 56.h),
            ElevatedButtonIconWidget(title: 'Save', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

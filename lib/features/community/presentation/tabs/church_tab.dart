import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChurchTab extends StatefulWidget {
  const ChurchTab({super.key});

  @override
  State<ChurchTab> createState() => _ChurchState();
}

class _ChurchState extends State<ChurchTab> {
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.h),
    child: Column(
      children: [
        const EditTextFieldWidget(
          prefix: ImageWidget(imageUrl: AppImage.searchIcon, fit: BoxFit.none),
          label: 'Search church by name',
        ),
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ImageWidget(imageUrl: AppImage.locationIcon),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  'Location Filter',
                  style: context.bodyMedium?.copyWith(color: AppColors.purple),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'All Churches',
            style: context.headlineLarge?.copyWith(
              fontSize: 20.sp,
              color: AppColors.purple,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: ListView.separated(
            itemCount: 20,
            itemBuilder: (_, __) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.grey750, width: .5.w),
              ),
              child: Row(
                children: [
                  Container(
                    height: 76.h,
                    width: 109.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.red50,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Potter’s Ville Church',
                                style: context.headlineLarge?.copyWith(
                                  fontSize: 16.sp,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            const ImageWidget(imageUrl: AppImage.pinAngleFillIcon),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Gbagada Campus',
                          style: context.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.grey700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Gbagada, Lagos, NG',
                          style: context.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.grey500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
          ),
        ),
      ],
    ),
  );
}

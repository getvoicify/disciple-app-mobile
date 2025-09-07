import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView(
        shrinkWrap: true,
        physics:
            NeverScrollableScrollPhysics(), // Disable scrolling in this ListView
        children: [
          SizedBox(height: 20.h),
          Text(
            'Qorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. ',
            style: context.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),
          Divider(),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageWidget(imageUrl: AppImage.locationIcon, fit: BoxFit.none),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  '2B, Residence Road, NCI bustop, Gbagada, Lagos',
                  style: context.bodyMedium?.copyWith(fontSize: 12.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            height: 156.h,
            margin: EdgeInsets.symmetric(horizontal: 28.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.red,
            ),
          ),
          SizedBox(height: 33.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(color: AppColors.purple3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact us',
                  style: context.headlineLarge?.copyWith(fontSize: 24.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Our friendly team would love to hear from you.',
                  style: context.bodyMedium?.copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: AppColors.purple,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageWidget(imageUrl: AppImage.emailIcon),
                        SizedBox(width: 8.w),
                        Text(
                          'Send Email',
                          style: context.bodyMedium?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Connect with us on our socials',
            style: context.headlineLarge?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          SizedBox(height: 12.h),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20.w,
            children:
                [
                      AppImage.facebookIcon,
                      AppImage.youtubeIcon,
                      AppImage.instagramIcon,
                      AppImage.threadIcon,
                      AppImage.xIcon,
                      AppImage.tiktokIcon,
                    ]
                    .map(
                      (icon) => ImageWidget(imageUrl: icon, fit: BoxFit.none),
                    )
                    .toList(),
          ),
          SizedBox(height: 20.h), // Add bottom padding
        ],
      ),
    );
  }
}

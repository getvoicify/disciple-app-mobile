import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondDevotionalsDetailsView extends StatefulWidget {
  const SecondDevotionalsDetailsView({super.key});

  @override
  State<SecondDevotionalsDetailsView> createState() =>
      _SecondDevotionalsDetailsViewState();
}

class _SecondDevotionalsDetailsViewState
    extends State<SecondDevotionalsDetailsView> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
      title: Text(AppString.pottersHeart),
    ),
    body: ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.whoAreYouPromoting,
                      style: context.headlineLarge?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      AppString.twoHoursAgo,
                      style: context.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              const ImageWidget(imageUrl: AppImage.bookmark),
              SizedBox(width: 8.w),
              const ImageWidget(imageUrl: AppImage.download),
              SizedBox(width: 8.w),
              const ImageWidget(imageUrl: AppImage.shareIcon2),
            ],
          ),
        ),

        const Divider(color: AppColors.purple, thickness: 2),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.grey50,
                  border: Border.all(color: AppColors.grey300, width: .5.w),
                ),
                child: Row(
                  children: [AppString.isa419, AppString.mk1010]
                      .map(
                        (chapter) => Expanded(
                          child: Text(
                            chapter,
                            style: context.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 21.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.grey50,
                  border: Border.all(color: AppColors.grey300, width: .5.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.foremIpsumTitle,
                      style: context.headlineLarge?.copyWith(fontSize: 16.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppString.loremIpsumContent,
                      style: context.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

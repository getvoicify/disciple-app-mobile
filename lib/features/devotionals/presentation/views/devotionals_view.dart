import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class DevotionalsView extends ConsumerStatefulWidget {
  const DevotionalsView({super.key});

  @override
  ConsumerState<DevotionalsView> createState() => _DevotionalsViewState();
}

class _DevotionalsViewState extends ConsumerState<DevotionalsView> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Devotionals'),
      leading: const ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
      actions: [
        const ImageWidget(imageUrl: AppImage.menuIcon),
        SizedBox(width: 16.w),
      ],
    ),
    body: SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          const EditTextFieldWidget(
            prefix: ImageWidget(
              imageUrl: AppImage.searchIcon,
              fit: BoxFit.none,
            ),
            label: 'Search devotional',
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Text(
                  'All',
                  style: context.headlineLarge?.copyWith(
                    fontSize: 20.sp,
                    color: AppColors.purple,
                  ),
                ),
                SizedBox(width: 48.w),
                Text(
                  'Favorites',
                  style: context.headlineLarge?.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.grey700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),

          Expanded(
            child: ListView.separated(
              itemCount: 20,
              itemBuilder: (_, _) => Row(
                children: [
                  Container(
                    height: 126.h,
                    width: 126.w,
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
                        Text(
                          'Potter’s Heart',
                          style: context.headlineLarge?.copyWith(
                            fontSize: 16.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'by Potter’sVille Church',
                          style: context.bodyMedium,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Author: Pastor kayode Oguta',
                          style: context.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        const Divider(),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            const ImageWidget(imageUrl: AppImage.likeIcon3),
                            SizedBox(width: 16.w),
                            const ImageWidget(imageUrl: AppImage.shareIcon2),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              separatorBuilder: (context, index) => SizedBox(height: 20.h),
            ),
          ),
        ],
      ),
    ),
  );
}

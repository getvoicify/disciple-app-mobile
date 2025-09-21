import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/build_tile_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class DevotionalsDetailsView extends ConsumerStatefulWidget {
  const DevotionalsDetailsView({super.key});

  @override
  ConsumerState<DevotionalsDetailsView> createState() =>
      _DevotionalsDetailsViewState();
}

class _DevotionalsDetailsViewState
    extends ConsumerState<DevotionalsDetailsView> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(height: 227.h, color: AppColors.purple3),
            SafeArea(
              bottom: false,

              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20.r),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: 8.w,
                      top: 8.h,
                      right: 8.w,
                      bottom: 32.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 134.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          'Potter’s Heart',
                          style: context.headlineLarge?.copyWith(
                            fontSize: 20.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'By Potter’s Ville Church',
                          style: context.bodyMedium,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Author: pastor Kayode Oguta',
                          style: context.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Recents',
                          style: context.headlineLarge?.copyWith(
                            fontSize: 20.sp,
                            color: AppColors.purple,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Saved',
                          style: context.headlineLarge?.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.grey700,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                'Sort by date',
                                style: context.headlineLarge?.copyWith(
                                  fontSize: 18.sp,
                                  color: AppColors.grey700,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            const ImageWidget(
                              imageUrl: AppImage.arrowDownIcon2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Flexible(
                  child: ListView.separated(
                    itemCount: 20,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (_, _) => const BuildTileWidget(),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

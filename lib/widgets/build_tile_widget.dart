import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildTileModel {
  final String? title;
  final String? content;
  final DateTime? date;

  BuildTileModel({this.title, this.content, this.date});
}

class BuildTileWidget extends StatelessWidget {
  const BuildTileWidget({super.key, this.model, this.onTap});

  final BuildTileModel? model;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8.r),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey200, width: .5.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  model?.title ?? '',
                  style: context.headlineMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  model?.date?.timeAgo ?? '',
                  style: context.bodyLarge?.copyWith(
                    fontSize: 10.sp,
                    fontStyle: FontStyle.italic,
                    color: AppColors.grey500,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            model?.content ?? '',
            style: context.headlineMedium?.copyWith(fontSize: 14.sp),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}

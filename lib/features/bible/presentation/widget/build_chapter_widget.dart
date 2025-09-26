import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildChapterWidget extends StatelessWidget {
  const BuildChapterWidget({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.verse,
  });

  final bool isFirst;
  final bool isLast;
  final BibleVerse verse;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.vertical(
        top: isFirst ? Radius.circular(8.r) : const Radius.circular(0),
        bottom: isLast ? Radius.circular(8.r) : const Radius.circular(0),
      ),
      border: Border.all(color: AppColors.grey200, width: .5.w),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${verse.bookName} ${verse.chapter}:${verse.verse}',
          style: context.headlineMedium?.copyWith(
            fontSize: 16.sp,
            color: AppColors.purple,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          verse.verseText,
          style: context.headlineMedium?.copyWith(fontSize: 20.sp),
        ),
        SizedBox(height: 8.h),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ImageWidget(imageUrl: AppImage.likeIcon2),
            ImageWidget(imageUrl: AppImage.editIcon),
          ],
        ),
      ],
    ),
  );
}

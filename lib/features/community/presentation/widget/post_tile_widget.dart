import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostTileWidget extends StatelessWidget {
  const PostTileWidget({super.key});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ImageWidget(
            imageUrl: AppImage.pinAngleFillIcon,
            fit: BoxFit.none,
          ),
          SizedBox(width: 8.w),
          Text(
            'Pinned',
            style: context.headlineMedium?.copyWith(fontSize: 12.sp),
          ),
        ],
      ),
      SizedBox(height: 8.h),
      Container(
        height: 251.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.red,
        ),
      ),
      SizedBox(height: 10.h),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ImageWidget(imageUrl: AppImage.likeIcon, fit: BoxFit.none),
          SizedBox(width: 4.w),
          Text('120', style: context.headlineMedium?.copyWith(fontSize: 12.sp)),
        ],
      ),
      SizedBox(height: 10.h),
      Text(
        'Qorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus.',
        style: context.bodyMedium?.copyWith(fontSize: 14.sp),
      ),
      SizedBox(height: 8.h),
      Text('2 hours ago', style: context.bodyMedium?.copyWith(fontSize: 12.sp)),
    ],
  );
}

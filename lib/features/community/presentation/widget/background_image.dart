import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BakgroundImage extends StatelessWidget {
  const BakgroundImage({super.key, required Church church}) : _church = church;

  final Church _church;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(12.r),
    child: Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ImageWidget(
          height: 538.h,
          width: double.infinity,
          imageUrl: _church.coverImageUrl ?? '',
          fit: BoxFit.cover,
        ),
        Container(
          height: 538.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _church.name ?? '',
                style: context.headlineLarge?.copyWith(
                  fontSize: 30.sp,
                  color: AppColors.white,
                ),
                maxLines: 2,
              ),
              SizedBox(height: 11.h),
              Text(
                _church.getAddress,
                style: context.bodyLarge?.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

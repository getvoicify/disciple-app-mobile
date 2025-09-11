import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget({super.key, required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(3.w),
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.purple,
    ),
    child: ImageWidget(imageUrl: icon, height: 17.h, width: 17.w),
  );
}

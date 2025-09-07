import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildAudioControllerWidget extends StatelessWidget {
  const BuildAudioControllerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _controller(icon: AppImage.boldBackArrow),
          _controller(icon: AppImage.playIcon, height: 64.h, width: 64.h),
          _controller(icon: AppImage.boldForwardArrow),
        ],
      ),
    );
  }

  Widget _controller({required String icon, double? height, double? width}) {
    return Container(
      height: height ?? 40.h,
      width: width ?? 40.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.purple3,
      ),
      child: ImageWidget(imageUrl: icon),
    );
  }
}

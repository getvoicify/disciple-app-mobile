import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/core/manager/keycloak_manager.dart';
import 'package:disciple/app/core/manager/model/user.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImageWidget extends ConsumerWidget {
  const ProfileImageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(keycloakManagerProvider).value?.user;

    if (user == null) {
      return GestureDetector(
        onTap: () {},
        child: CircleAvatar(
          backgroundColor: AppColors.purple100,
          child: ImageWidget(
            imageUrl: AppImage.profilePlaceholder,
            width: 40.w,
            height: 40.h,
            fit: BoxFit.scaleDown,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {},
      child: CircleAvatar(
        backgroundColor: AppColors.purple100,
        child: Text(
          user.initial,
          style: context.headlineLarge?.copyWith(fontSize: 24.sp),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
    );
  }
}

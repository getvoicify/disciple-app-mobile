import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/core/manager/keycloak_manager.dart';
import 'package:disciple/app/core/manager/model/user.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImageWidget extends ConsumerWidget {
  const ProfileImageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(keycloakManagerProvider).value?.user;

    return CircleAvatar(
      backgroundColor: AppColors.grey200,
      child: Text(
        user?.initial ?? '',
        style: context.headlineLarge?.copyWith(fontSize: 24.sp),
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }
}

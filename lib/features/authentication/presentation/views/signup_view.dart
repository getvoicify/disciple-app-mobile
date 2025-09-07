import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/elevated_button_widget.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ImageWidget(imageUrl: AppImage.authBackground, fit: BoxFit.contain),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 40.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sign Up',
                      style: context.headlineMedium?.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Kindly enter your details.',
                      style: context.bodyMedium?.copyWith(fontSize: 16.sp),
                    ),
                    SizedBox(height: 40.h),
                    EditTextFieldWidget(
                      titleWidget: SizedBox.shrink(),
                      label: 'Enter your email',
                    ),
                    SizedBox(height: 16.h),
                    EditTextFieldWidget(
                      titleWidget: SizedBox.shrink(),
                      label: 'Password',
                      suffixIcon: ImageWidget(
                        imageUrl: AppImage.eyeIcon,
                        fit: BoxFit.none,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    EditTextFieldWidget(
                      titleWidget: SizedBox.shrink(),
                      label: 'Confirm Password',
                      suffixIcon: ImageWidget(
                        imageUrl: AppImage.eyeIcon,
                        fit: BoxFit.none,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    ElevatedButtonIconWidget(
                      onPressed: () {},
                      title: 'Sign Up',
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButtonIconWidget(
                      onPressed: () {},
                      title: 'Sign in with Google',
                      backgroundColor: AppColors.white,
                      outlinedColor: AppColors.grey200,
                      textStyle: context.bodyMedium?.copyWith(
                        color: AppColors.black,
                      ),
                      iconAlignment: IconAlignment.start,
                      icon: ImageWidget(
                        imageUrl: AppImage.googleIcon,
                        fit: BoxFit.none,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: context.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: context.headlineMedium?.copyWith(
                              color: AppColors.purple,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

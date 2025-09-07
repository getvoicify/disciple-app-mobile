import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/elevated_button_widget.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
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
                      'Log In To Your Account',
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
                    SizedBox(height: 40.h),
                    ElevatedButtonIconWidget(onPressed: () {}, title: 'Log In'),
                    SizedBox(height: 24.h),
                    ElevatedButtonIconWidget(
                      onPressed: () {},
                      title: 'Sign up with Google',
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
                        text: 'Don\'t have an account? ',
                        style: context.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Sign up',
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
                    Text(
                      'Forgot password',
                      style: context.headlineMedium?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.purple,
                      ),
                    ),
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

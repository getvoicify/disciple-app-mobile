import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle get headlineLarge => TextStyle(
  fontFamily: AppFonts.inter,
  color: AppColors.black,
  fontWeight: FontWeight.w700,
  fontSize: 36.sp,
);

TextStyle get headlineMedium =>
    headlineLarge.copyWith(fontSize: 36.sp, fontWeight: FontWeight.w400);

TextStyle get bodyMedium => headlineMedium.copyWith(
  fontSize: 14.sp,
  fontWeight: FontWeight.w400,
  color: AppColors.grey700,
);

TextStyle get bodyLarge =>
    headlineMedium.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500);

TextStyle get titleSmall => headlineMedium.copyWith(
  fontSize: 12.sp,
  fontWeight: FontWeight.w500,
  color: AppColors.grey500,
);

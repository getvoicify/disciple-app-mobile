import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData lightTheme = ThemeData.light(useMaterial3: false).copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: AppColors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.white,
    elevation: 0,
    surfaceTintColor: AppColors.white,
    titleTextStyle: headlineLarge.copyWith(fontSize: 24.sp),
    centerTitle: true,
    iconTheme: const IconThemeData(color: AppColors.black),
  ),
  cardColor: AppColors.white,
  textTheme: TextTheme(
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    bodyMedium: bodyMedium,
    bodyLarge: bodyLarge,
    titleSmall: titleSmall,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.purple,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.resolveWith((states) => 0),
      enableFeedback: true,
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.purple2;
        }
        return AppColors.purple;
      }),
      textStyle: WidgetStateProperty.resolveWith(
        (states) => bodyMedium.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: WidgetStateProperty.resolveWith(
        (states) =>
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      foregroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return AppColors.white;

        return AppColors.white;
      }),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const BorderSide(color: AppColors.purple2);
        }
        return const BorderSide(color: AppColors.purple);
      }),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    labelStyle: bodyMedium.copyWith(
      overflow: TextOverflow.ellipsis,
      color: AppColors.grey500,
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
    ),
    hintStyle: bodyMedium.copyWith(
      color: AppColors.grey500,
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    fillColor: AppColors.grey50,
    filled: true,
    errorMaxLines: 5,
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    errorStyle: bodyMedium.copyWith(
      color: Colors.red,
      fontSize: 12.sp,
      overflow: TextOverflow.visible,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: AppColors.grey300),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: AppColors.grey300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: AppColors.grey300),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: Colors.red),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide.none,
    ),
  ),
  tabBarTheme: TabBarThemeData(
    labelColor: AppColors.white,
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(7.r),
      color: AppColors.purple,
    ),
    unselectedLabelColor: AppColors.grey700,
    indicatorColor: AppColors.purple,
    dividerColor: Colors.transparent,
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorAnimation: TabIndicatorAnimation.elastic,
    unselectedLabelStyle: bodyMedium.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    ),
    labelStyle: bodyMedium.copyWith(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.white;
      }
      return AppColors.white;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.purple;
      }
      return AppColors.grey200;
    }),
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return AppColors.purple;
      }
      return null;
    }),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: AppColors.grey50,
    textStyle: bodyMedium.copyWith(fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.purple25,
    elevation: 10,
    type: BottomNavigationBarType.shifting,
    selectedLabelStyle: bodyMedium.copyWith(color: AppColors.purple),
    unselectedLabelStyle: bodyMedium.copyWith(color: AppColors.grey700),
    showSelectedLabels: true,
    showUnselectedLabels: false,
    selectedItemColor: AppColors.purple,
    unselectedItemColor: AppColors.grey300,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: AppColors.white,
    modalBarrierColor: const Color.fromRGBO(
      117,
      117,
      126,
      1,
    ).withValues(alpha: .40),
    showDragHandle: true,
    dragHandleColor: AppColors.grey200,

    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
  ),
);

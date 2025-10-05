import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Sheets {
  static Future<T?> dialog<T>({
    required Widget child,
    Color? backgroundColor = Colors.transparent,
  }) => showGeneralDialog(
    context: PageNavigator.context,
    barrierLabel: 'barrierLabel',
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) =>
        Dialog(backgroundColor: backgroundColor, child: child),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

      final scaleAnimation = Tween<double>(
        begin: 0.95,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack));

      return SlideTransition(
        position: slideAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: animation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: child,
            ),
          ),
        ),
      );
    },
  );

  static Future<T?> showSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? background,
    Color? barrierColor,
  }) async => await showModalBottomSheet<T>(
    isDismissible: isDismissible,
    isScrollControlled: true,
    enableDrag: enableDrag,
    context: PageNavigator.context,
    backgroundColor: background,
    barrierColor: barrierColor,
    builder: (_) => child,
  );
}

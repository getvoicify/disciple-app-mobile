import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElevatedButtonIconWidget extends StatelessWidget {
  const ElevatedButtonIconWidget({
    super.key,
    required this.onPressed,
    this.title = '',
    this.height = 48,
    this.width = double.infinity,
    this.isBusy = false,
    this.backgroundColor,
    this.outlinedColor,
    this.textStyle,
    this.icon,
    this.loadingTitle,
    this.iconAlignment = IconAlignment.end,
  });

  final double? height;
  final double? width;
  final String title;
  final void Function()? onPressed;
  final bool isBusy;
  final Color? backgroundColor;
  final Color? outlinedColor;
  final TextStyle? textStyle;
  final Widget? icon;
  final IconAlignment iconAlignment;
  final String? loadingTitle;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height?.h,
    width: width,
    child: ElevatedButton.icon(
      onPressed: isBusy || onPressed == null
          ? null
          : () async {
              await HapticFeedback.selectionClick();
              if (onPressed != null) onPressed!();
            },
      style: ButtonStyle(
        side: WidgetStatePropertyAll(
          BorderSide(color: outlinedColor ?? Colors.transparent),
        ),
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
      ),
      label: Text(
        isBusy ? (loadingTitle ?? 'Please wait...') : title,
        style: textStyle,
      ),
      icon: isBusy ? const CupertinoActivityIndicator() : icon,
      iconAlignment: iconAlignment,
    ),
  );
}

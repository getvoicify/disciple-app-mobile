import 'dart:async';

import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';

// Trigger a notification using OverlaySupport
// Display the notification using the MessageNotification widget
void triggerNotificationTray(
  String message, {
  bool error = false,
  bool showIcon = true,
  Duration? duration,
  bool ignoreIfNull = false,
}) {
  if (ignoreIfNull) return;
  showOverlayNotification(
    (_) =>
        MessageNotification(message: message, error: error, showIcon: showIcon),
    duration: duration ?? const Duration(milliseconds: 4000),
  );
}

class MessageNotification extends StatefulWidget {
  final String message;
  final bool error;
  final bool showIcon;

  const MessageNotification({
    super.key,
    required this.message,
    this.error = false,
    this.showIcon = true,
  });

  @override
  State<MessageNotification> createState() => _MessageNotificationState();
}

class _MessageNotificationState extends State<MessageNotification>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    unawaited(_triggerFeedback());

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.ease,
    );
    unawaited(controller.forward());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _triggerFeedback() async {
    await HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
    scale: animation,
    child: GestureDetector(
      onTap: () => context.dismissTrey(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: widget.error ? AppColors.red : AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: widget.error ? Colors.transparent : AppColors.white,
          ),
        ),
        margin: EdgeInsets.only(top: kToolbarHeight, left: 16.w, right: 16.w),
        child: Material(
          color: Colors.transparent,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.message,
                  style: context.headlineLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () => context.dismissTrey(),
                child: const Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

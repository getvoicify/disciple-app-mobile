import 'package:disciple/app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatDividerWidget extends StatelessWidget {
  const ChatDividerWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider()),
      SizedBox(width: 8.w),
      Text(title, style: context.bodyMedium),
      SizedBox(width: 8.w),
      const Expanded(child: Divider()),
    ],
  );
}

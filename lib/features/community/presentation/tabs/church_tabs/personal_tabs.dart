import 'package:disciple/features/community/presentation/widget/community_tile_widget.dart';
import 'package:disciple/widgets/floating_side_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayerWallTabs extends StatefulWidget {
  const PrayerWallTabs({super.key});

  @override
  State<PrayerWallTabs> createState() => _PrayerWallTabsState();
}

class _PrayerWallTabsState extends State<PrayerWallTabs> {
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      ListView.separated(
        itemCount: 20,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (_, index) => const CommuityTIleWidget(),
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
      ),
      const FloatingSideButtonWidget(title: 'Create New'),
    ],
  );
}

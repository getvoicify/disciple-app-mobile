import 'package:disciple/features/community/presentation/widget/community_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayerWallTabs extends StatefulWidget {
  const PrayerWallTabs({super.key});

  @override
  State<PrayerWallTabs> createState() => _PrayerWallTabsState();
}

class _PrayerWallTabsState extends State<PrayerWallTabs> {
  @override
  Widget build(BuildContext context) => ListView.separated(
    itemCount: 3,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
<<<<<<< HEAD
    itemBuilder: (_, _) => const CommuityTIleWidget(isJoined: true),
=======
    itemBuilder: (_, index) => const CommuityTIleWidget(isJoined: true),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
    separatorBuilder: (context, index) => SizedBox(height: 12.h),
  );
}

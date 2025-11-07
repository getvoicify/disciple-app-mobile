import 'package:disciple/features/community/presentation/widget/friends_tile_widget.dart';
import 'package:disciple/widgets/floating_side_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FriendsTabs extends StatefulWidget {
  const FriendsTabs({super.key});

  @override
  State<FriendsTabs> createState() => _FriendsTabsState();
}

class _FriendsTabsState extends State<FriendsTabs> {
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      ListView.separated(
        itemCount: 20,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
<<<<<<< HEAD
        itemBuilder: (_, _) => const FriendsTileWidget(),
=======
        itemBuilder: (_, index) => const FriendsTileWidget(),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
      ),
      const FloatingSideButtonWidget(title: 'Add Friends '),
    ],
  );
}

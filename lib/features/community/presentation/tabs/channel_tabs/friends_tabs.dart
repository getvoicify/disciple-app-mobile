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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          itemCount: 20,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemBuilder: (_, __) => FriendsTileWidget(),
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
        ),
        FloatingSideButtonWidget(title: 'Add Friends '),
      ],
    );
  }
}

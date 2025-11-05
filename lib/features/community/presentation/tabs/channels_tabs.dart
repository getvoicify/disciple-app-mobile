import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/community/presentation/tabs/channel_tabs/friends_tabs.dart';
import 'package:disciple/features/community/presentation/tabs/channel_tabs/personal_tabs.dart';
import 'package:disciple/features/community/presentation/tabs/channel_tabs/prayer_wall_tabs.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChannelsTabs extends StatefulWidget {
  const ChannelsTabs({super.key});

  @override
  State<ChannelsTabs> createState() => _ChannelsTabsState();
}

class _ChannelsTabsState extends State<ChannelsTabs>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        SizedBox(height: 28.h),
        TabBar(
          controller: _tabController,
          labelStyle: context.bodyLarge,
          labelColor: AppColors.black,
          unselectedLabelStyle: context.bodyLarge?.copyWith(
            color: AppColors.grey500,
          ),
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.purple, width: 2.w),
            ),
          ),
          tabs: [
            'Prayer Wall',
            'Personal',
            'Friends',
          ].map((element) => Tab(text: element)).toList(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const EditTextFieldWidget(
            prefix: ImageWidget(
              imageUrl: AppImage.searchIcon,
              fit: BoxFit.none,
            ),
            label: 'Search by title or church',
          ),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [PrayerWallTabs(), PersonalTabs(), FriendsTabs()],
          ),
        ),
      ],
    ),
  );
}

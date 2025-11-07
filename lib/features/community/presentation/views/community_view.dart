<<<<<<< HEAD
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/features/community/presentation/tabs/channels_tabs.dart';
import 'package:disciple/widgets/decorated_tab.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:disciple/features/community/presentation/tabs/church_tab.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView>
=======
import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/features/community/presentation/tabs/channels_tabs.dart';
import 'package:disciple/features/community/presentation/tabs/church_tab.dart';
import 'package:disciple/widgets/decorated_tab.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:disciple/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CommunityView extends ConsumerStatefulWidget {
  const CommunityView({super.key});

  @override
  ConsumerState<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends ConsumerState<CommunityView>
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Community'),
      actions: [
        const ImageWidget(imageUrl: AppImage.notificationIcon),
        SizedBox(width: 16.w),
<<<<<<< HEAD
        const CircleAvatar(),
=======
        const ProfileImageWidget(),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
        SizedBox(width: 16.w),
      ],
      bottom: DecoratedTabBar(
        tabBar: TabBar(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          controller: _tabController,
          tabs: [
            'Church',
            'Channels',
          ].map((element) => Tab(text: element)).toList(),
        ),
      ),
    ),
    body: TabBarView(
      controller: _tabController,
      children: [const ChurchTab(), const ChannelsTabs()],
    ),
  );
}

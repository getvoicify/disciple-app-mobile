import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/community/presentation/tabs/channel_tabs/prayer_wall_tabs.dart';
import 'package:disciple/features/community/presentation/tabs/church_tabs/overview_tab.dart';
import 'package:disciple/features/community/presentation/tabs/church_tabs/posts_tab.dart';
import 'package:disciple/widgets/delegate/sticky_appbar_delegate.dart';
import 'package:disciple/widgets/elevated_button_widget.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChurchView extends StatefulWidget {
  const ChurchView({super.key});

  @override
  State<ChurchView> createState() => _ChurchViewState();
}

class _ChurchViewState extends State<ChurchView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 20.h),
            child: ElevatedButtonIconWidget(
              height: 26.h,
              width: null,
              backgroundColor: AppColors.purple50,
              textStyle: context.headlineLarge?.copyWith(
                color: AppColors.purple,
                fontSize: 12.sp,
              ),
              title: 'Follow Church',
              onPressed: () {},
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 16.h),
                    height: 538.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: 84.w,
                          height: 67.h,
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            color: Colors.primaries[index],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: const BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  border: Border(
                    bottom: BorderSide(color: AppColors.purple, width: 2.0),
                  ),
                ),
                indicatorPadding: EdgeInsets.only(bottom: 10.h, top: 10.h),
                tabs: [
                  'Overview',
                  'Posts',
                  'Prayer Wall',
                ].map((element) => Tab(text: element)).toList(),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [OverviewTab(), PostTab(), PrayerWallTabs()],
        ),
      ),
    );
  }
}

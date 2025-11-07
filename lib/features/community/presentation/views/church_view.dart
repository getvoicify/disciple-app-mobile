<<<<<<< HEAD
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/community/presentation/tabs/channel_tabs/prayer_wall_tabs.dart';
import 'package:disciple/features/community/presentation/tabs/church_tabs/overview_tab.dart';
import 'package:disciple/features/community/presentation/tabs/church_tabs/posts_tab.dart';
=======
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/features/community/presentation/notifier/church_notifier.dart';
import 'package:disciple/features/community/presentation/tabs/channel_tabs/prayer_wall_tabs.dart';
import 'package:disciple/features/community/presentation/tabs/church_tabs/overview_tab.dart';
import 'package:disciple/features/community/presentation/tabs/church_tabs/posts_tab.dart';
import 'package:disciple/features/community/presentation/widget/background_image.dart';
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
import 'package:disciple/widgets/delegate/sticky_appbar_delegate.dart';
import 'package:disciple/widgets/elevated_button_widget.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChurchView extends StatefulWidget {
  const ChurchView({super.key});

  @override
  State<ChurchView> createState() => _ChurchViewState();
}

class _ChurchViewState extends State<ChurchView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class ChurchView extends ConsumerStatefulWidget {
  const ChurchView({super.key, required this.church});

  final Church church;

  @override
  ConsumerState<ChurchView> createState() => _ChurchViewState();
}

class _ChurchViewState extends ConsumerState<ChurchView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late Church _church;
  late ChurchNotifier _churchNotifier;
  final CancelToken _cancelToken = CancelToken();
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
<<<<<<< HEAD
=======
    _church = widget.church;
    _churchNotifier = ref.read(churchProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _churchNotifier.getGalleries(
        parameter: _church.id ?? '',
        cancelToken: _cancelToken,
      );
    });
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
    super.initState();
  }

  @override
<<<<<<< HEAD
=======
  void dispose() {
    _cancelToken.cancel();
    _tabController?.dispose();
    super.dispose();
  }

  @override
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
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
<<<<<<< HEAD
      headerSliverBuilder: (_, _) => [
=======
      headerSliverBuilder: (_, innerBoxIsScrolled) => [
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
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
=======
                SizedBox(height: 16.h),
                BakgroundImage(church: _church),
                SizedBox(height: 20.h),
                Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(churchProvider);
                    final galleries = state.galleries;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              galleries.length,
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
                    );
                  },
                ),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
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
<<<<<<< HEAD
=======
              labelColor: AppColors.black,
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
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
        children: [
<<<<<<< HEAD
          const OverviewTab(),
=======
          OverviewTab(church: _church),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
          const PostTab(),
          const PrayerWallTabs(),
        ],
      ),
    ),
  );
}

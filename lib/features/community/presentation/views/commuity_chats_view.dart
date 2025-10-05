import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/community/presentation/widget/receiver_chat_buble_widget.dart';
import 'package:disciple/features/community/presentation/widget/sender_chat_buble_widget.dart';
import 'package:disciple/widgets/delegate/sticky_appbar_delegate.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:disciple/features/community/presentation/widget/message_entry_widget.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class CommunityChatsView extends StatefulWidget {
  const CommunityChatsView({super.key});

  @override
  State<CommunityChatsView> createState() => _CommunityChatsViewState();
}

class _CommunityChatsViewState extends State<CommunityChatsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<String> _tabs = ["Messages", "Members"];
  // Mock data for member count
  final int _memberCount = 24;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 16.w),
      child: NestedScrollView(
        headerSliverBuilder: (_, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCustomAppBar(),
                SizedBox(height: 14.h),
                _buildChatHeader(),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.grey700,
                  unselectedLabelColor: AppColors.grey500,
                  labelStyle: context.headlineMedium?.copyWith(fontSize: 14.sp),
                  unselectedLabelStyle: context.headlineMedium?.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.grey500,
                  ),
                  indicator: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(4.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey200,
                        blurRadius: 2.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  tabs: [
                    Tab(text: _tabs[0]),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_tabs[1]),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey750,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Text(
                              '4',
                              style: context.headlineMedium?.copyWith(
                                fontSize: 12.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_buildMessagesTab(), _buildMembersTab()],
        ),
      ),
    ),
  );

  Widget _buildMessagesTab() => Column(
    children: [
      SizedBox(height: 16.h),
      Expanded(
        child: ListView.separated(
          separatorBuilder: (_, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            if (index.isEven) return const ReceiverChatBubleWidget();
            return const SenderChatBubleWidget();
          },
          itemCount: 20,
        ),
      ),
      SizedBox(height: 16.h),
      const MessageEntryWidget(),
    ],
  );

  Widget _buildMembersTab() => ListView.separated(
    itemCount: _memberCount,
    separatorBuilder: (_, index) => SizedBox(height: 12.h),
    itemBuilder: (context, index) =>
        _buildMemberItem(name: 'Member ${index + 1}', isAdmin: index == 0),
  );

  Widget _buildMemberItem({required String name, bool isAdmin = false}) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    elevation: .3,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          const CircleAvatar(radius: 20),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              name,
              style: context.headlineMedium?.copyWith(fontSize: 16.sp),
            ),
          ),
          SizedBox(width: 16.w),
          const ImageWidget(imageUrl: AppImage.healthIconsCancelOutline),
        ],
      ),
    ),
  );

  Widget _buildCustomAppBar() => Row(
    children: [
      const ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
      const Spacer(),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.purple,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Join call',
              style: context.bodyMedium?.copyWith(color: AppColors.white),
            ),
            SizedBox(width: 8.w),
            const ImageWidget(imageUrl: AppImage.callIcon, fit: BoxFit.none),
          ],
        ),
      ),
      SizedBox(width: 44.w),
      const CircleAvatar(),
      SizedBox(width: 8.w),
      Center(
        child: Text(
          'Admin',
          style: context.headlineMedium?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      SizedBox(width: 16.w),
    ],
  );

  Widget _buildChatHeader() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              'Peniel Hour',
              style: context.headlineLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 24.sp,
              ),
              textAlign: TextAlign.left,
              maxLines: 1,
            ),
          ),
          const ImageWidget(imageUrl: AppImage.penIcon, fit: BoxFit.none),
        ],
      ),
      SizedBox(height: 8.h),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildInfoItem(
              AppImage.calendarIcon,
              'Every Saturday',
              AppColors.purple,
            ),
            SizedBox(width: 16.w),
            _buildInfoItem(AppImage.clockIcon2, '6AM WAT', AppColors.purple),
            SizedBox(width: 16.w),
            _buildInfoItem(AppImage.ellipseIcon, 'Ongoing', AppColors.red),
          ],
        ),
      ),
      SizedBox(height: 16.h),
      const Text(
        'Horem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.',
      ),
      SizedBox(height: 16.h),
    ],
  );

  Widget _buildInfoItem(String iconPath, String text, Color textColor) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ImageWidget(imageUrl: iconPath, fit: BoxFit.none),
      SizedBox(width: 8.w),
      Text(
        text,
        style: context.headlineMedium?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: textColor,
        ),
      ),
    ],
  );
}

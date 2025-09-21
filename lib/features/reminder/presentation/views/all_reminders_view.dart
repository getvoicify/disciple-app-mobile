import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/floating_side_action_button.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:disciple/features/reminder/presentation/widget/reminder_tile_widget.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class AllRemindersView extends ConsumerStatefulWidget {
  const AllRemindersView({super.key});

  @override
  ConsumerState<AllRemindersView> createState() => _AllRemindersViewState();
}

class _AllRemindersViewState extends ConsumerState<AllRemindersView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
      elevation: 0,
      title: const Text('Reminders'),
    ),
    body: Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          // Search Bar
          const EditTextFieldWidget(
            prefix: ImageWidget(
              imageUrl: AppImage.searchIcon,
              fit: BoxFit.none,
            ),
            label: 'Search Reminder',
          ),
          SizedBox(height: 20.h),
          // Tab Bar
          TabBar(
            controller: _tabController,
            indicator: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.purple)),
            ),
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Active'),
              Tab(text: 'Inactive'),
            ],
            onTap: (index) {
              // Handle tab selection
              setState(() {});
            },
          ),
          SizedBox(height: 16.h),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Reminders Tab
                _buildRemindersList(),

                // Active Reminders Tab
                _buildRemindersList(isActive: true),

                // Inactive Reminders Tab
                _buildRemindersList(isActive: false),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildRemindersList({bool? isActive}) => Stack(
    children: [
      ListView.separated(
        itemCount: Colors.primaries.length,
        shrinkWrap: true,
        itemBuilder: (_, index) => const ReminderTileWidget(),
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
      ),
      const FloatingSideButtonWidget(title: 'Create New'),
    ],
  );
}

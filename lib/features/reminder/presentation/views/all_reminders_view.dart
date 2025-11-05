import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/reminder/presentation/notifier/reminder_notifier.dart';
import 'package:disciple/widgets/back_arrow_widget.dart';
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
      leading: const BackArrowWidget(),
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

  Widget _buildRemindersList({bool? isActive}) {
    final remindersStream = ref
        .watch(reminderProvider.notifier)
        .watchReminder();

    return Stack(
      children: [
        StreamBuilder<List<ReminderData>>(
          stream: remindersStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Reminders Found'));
            }

            final reminders = snapshot.data ?? [];

            return ListView.separated(
              itemCount: reminders.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final reminder = reminders[index];

                return ReminderTileWidget(
                  title: reminder.title,
                  date: 'Every ${reminder.scheduledAt?.weekDay}',
                  time: reminder.scheduledAt?.time,
                  color: reminder.colorValue?.toColor,
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
            );
          },
        ),
        FloatingSideButtonWidget(
          title: 'Create New',
          onTap: () => PageNavigator.pushRoute(const CreateReminderRoute()),
        ),
      ],
    );
  }
}

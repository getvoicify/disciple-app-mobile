import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/reminder/presentation/notifier/reminder_notifier.dart';
import 'package:disciple/widgets/back_arrow_widget.dart';
import 'package:disciple/widgets/calendar/module/calendar_notifier.dart';
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
    _searchController.addListener(() => setState(() {})); // Rebuild on search
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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),

          // Search Bar
          EditTextFieldWidget(
            controller: _searchController,
            prefix: const ImageWidget(
              imageUrl: AppImage.searchIcon,
              fit: BoxFit.none,
            ),
            label: 'Search Reminder',
          ),

          SizedBox(height: 20.h),

          // Tabs
          TabBar(
            controller: _tabController,
            indicator: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.purple)),
            ),
            isScrollable: true,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Active'),
              Tab(text: 'Inactive'),
            ],
          ),

          SizedBox(height: 16.h),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRemindersList(), // All
                _buildRemindersList(status: true), // Active (Upcoming)
                _buildRemindersList(status: false), // Inactive (Past)
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildRemindersList({bool? status}) {
    final stream = ref
        .read(reminderProvider.notifier)
        .watchReminder(
          status: status,
          searchText: _searchController.text.trim(),
        );

    return Stack(
      children: [
        StreamBuilder<List<ReminderData>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Reminders Found'));
            }

            final reminders = snapshot.data!;

            return ListView.separated(
              itemCount: reminders.length,
              itemBuilder: (_, index) {
                final reminder = reminders[index];
                return ReminderTileWidget(
                  isNotActive: status == false,
                  title: reminder.title,
                  date: 'Every ${reminder.scheduledAt?.weekDay}',
                  time: reminder.scheduledAt?.time,
                  color: reminder.colorValue?.toColor,
                  onTap: () => _onTap(reminder),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
            );
          },
        ),

        // Create Button
        FloatingSideButtonWidget(
          title: 'Create New',
          onTap: () => PageNavigator.pushRoute(const CreateReminderRoute()),
        ),
      ],
    );
  }

  Future<void> _onTap(ReminderData reminder) async {
    ref.read(calendarProvider.notifier)
      ..setRange(reminder.scheduledAt, null)
      ..setOtherValues(reminder);
    await PageNavigator.pushRoute(const CreateReminderRoute());
  }
}

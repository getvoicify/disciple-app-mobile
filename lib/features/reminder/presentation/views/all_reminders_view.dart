import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
<<<<<<< HEAD
=======
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/reminder/presentation/notifier/reminder_notifier.dart';
import 'package:disciple/widgets/back_arrow_widget.dart';
import 'package:disciple/widgets/calendar/module/calendar_notifier.dart';
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/floating_side_action_button.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:disciple/features/reminder/presentation/widget/reminder_tile_widget.dart';

<<<<<<< HEAD
class AllRemindersView extends StatefulWidget {
  const AllRemindersView({super.key});

  @override
  State<AllRemindersView> createState() => _AllRemindersViewState();
}

class _AllRemindersViewState extends State<AllRemindersView>
=======
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class AllRemindersView extends ConsumerStatefulWidget {
  const AllRemindersView({super.key});

  @override
  ConsumerState<AllRemindersView> createState() => _AllRemindersViewState();
}

class _AllRemindersViewState extends ConsumerState<AllRemindersView>
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
<<<<<<< HEAD
=======
    _searchController.addListener(() => setState(() {})); // Rebuild on search
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
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
<<<<<<< HEAD
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
=======
      leading: const BackArrowWidget(),
      elevation: 0,
      title: const Text('Reminders'),
    ),
    body: Stack(
      children: [
        Padding(
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
        // Create Button
        FloatingSideButtonWidget(
          title: 'Create New',
          onTap: () => PageNavigator.pushRoute(const CreateReminderRoute()),
        ),
      ],
    ),
  );

  Widget _buildRemindersList({bool? status}) {
    final stream = ref
        .read(reminderProvider.notifier)
        .watchReminder(
          status: status,
          searchText: _searchController.text.trim(),
        );

    return StreamBuilder<List<ReminderData>>(
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
              date: reminder.scheduledAt?.monthDateYear,
              time: reminder.scheduledAt?.time,
              color: reminder.colorValue?.toColor,
              onTap: () => _onTap(reminder),
            );
          },
          separatorBuilder: (_, _) => SizedBox(height: 12.h),
        );
      },
    );
  }

  Future<void> _onTap(ReminderData reminder) async {
    ref.read(calendarProvider.notifier)
      ..setRange(reminder.scheduledAt, null)
      ..setOtherValues(reminder);
    await PageNavigator.pushRoute(const CreateReminderRoute());
  }
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}

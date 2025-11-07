import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/reminder/presentation/notifier/reminder_notifier.dart';
import 'package:disciple/features/reminder/presentation/widget/reminder_tile_widget.dart';
import 'package:disciple/widgets/calendar/calendar_widget.dart';
import 'package:disciple/widgets/calendar/module/calendar_notifier.dart';
import 'package:disciple/widgets/floating_side_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class TodayRemindersView extends ConsumerStatefulWidget {
  const TodayRemindersView({super.key});

  @override
  ConsumerState<TodayRemindersView> createState() => _TodayRemindersViewState();
}

class _TodayRemindersViewState extends ConsumerState<TodayRemindersView> {
  late final CalendarNotifier _calendarNotifier;

  @override
  void initState() {
    _calendarNotifier = ref.read(calendarProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0,
      backgroundColor: AppColors.purple3,
      title: const Text('Reminders'),
    ),
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(height: 100.h, color: AppColors.purple3),
            SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'August 1',
                                style: context.bodyMedium?.copyWith(
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Today’s Reminder',
                                style: context.headlineLarge?.copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          'See All',
                          style: context.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.purple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    height: 130.h,
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8.r),
                      ),
                      // child: const CalendarWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: Stack(
            children: [
              _buildRemindersList(),
              FloatingSideButtonWidget(
                title: 'Create New',
                onTap: () =>
                    PageNavigator.pushRoute(const CreateReminderRoute()),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildRemindersList() {
    final stream = ref
        .read(reminderProvider.notifier)
        .watchReminder(status: true);

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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemBuilder: (_, index) {
            final reminder = reminders[index];
            return ReminderTileWidget(
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
}

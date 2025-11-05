import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/floating_side_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:disciple/features/reminder/presentation/widget/reminder_tile_widget.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class TodayRemindersView extends ConsumerStatefulWidget {
  const TodayRemindersView({super.key});

  @override
  ConsumerState<TodayRemindersView> createState() => _TodayRemindersViewState();
}

class _TodayRemindersViewState extends ConsumerState<TodayRemindersView> {
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
              ListView.separated(
                itemCount: Colors.primaries.length,
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
                shrinkWrap: true,
                itemBuilder: (_, index) => const ReminderTileWidget(
                  title: 'Reminder',
                  date: '12:00 PM',
                  time: '12:00 PM',
                  color: Colors.purple,
                ),
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
              ),
              const FloatingSideButtonWidget(title: 'Create New'),
            ],
          ),
        ),
      ],
    ),
  );
}

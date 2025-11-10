import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_fonts.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/calendar/module/calendar_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomTableCalendar extends ConsumerWidget {
  final RangeSelectionMode? rangeSelectionMode;
  final void Function(PageController)? pageControllerCallback;
  final bool isTodayHighlighted;
  final CalendarFormat? calendarFormat;

  const CustomTableCalendar({
    super.key,
    this.rangeSelectionMode,
    this.pageControllerCallback,
    this.isTodayHighlighted = false,
    this.calendarFormat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final present = DateTime.now();
    final calendarState = ref.watch(calendarProvider);

    return TableCalendar(
      firstDay: DateTime(present.year, present.month),
      lastDay: DateTime(present.year + 5, present.month, 0),
      focusedDay: calendarState.focusedDay,
      headerVisible: false,
      startingDayOfWeek: StartingDayOfWeek.monday,
      onCalendarCreated: pageControllerCallback,
      calendarFormat: calendarFormat ?? CalendarFormat.week,
      selectedDayPredicate: (day) => isSameDay(calendarState.selectedDay, day),
      rangeStartDay: calendarState.rangeStart,
      rangeEndDay: calendarState.rangeEnd,
      onPageChanged: (focusedDay) =>
          ref.read(calendarProvider.notifier).setFocusedDay(focusedDay),
      enabledDayPredicate: (day) => !_isPastDay(day),
      onDaySelected: (selectedDay, focusedDay) {
        if (_isPastDay(selectedDay)) return;
        ref.read(calendarProvider.notifier)
          ..setSelectedDay(selectedDay)
          ..setFocusedDay(selectedDay);
      },
      onRangeSelected: (start, end, focusedDay) {
        if (start != null && _isPastDay(start)) return;
        ref.read(calendarProvider.notifier)
          ..setFocusedDay(focusedDay)
          ..setRange(start, end);
      },
      daysOfWeekVisible:
          calendarState.calendarFrequency != CalendarFrequency.monthly,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: context.headlineLarge!.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.inter,
        ),
        weekendStyle: context.headlineLarge!.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.inter,
        ),
      ),
      rangeSelectionMode: rangeSelectionMode ?? RangeSelectionMode.toggledOff,
      daysOfWeekHeight: 50.h,
      calendarStyle: _calendarStyle(context, isTodayHighlighted),
    );
  }

  CalendarStyle _calendarStyle(BuildContext context, bool isTodayHighlighted) {
    final mutedText = _dayTextStyle(
      context,
    ).copyWith(color: AppColors.grey250, fontWeight: FontWeight.w400);

    final dayText = _dayTextStyle(context);

    const circleDecoration = BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.purple,
    );

    final circleText = _dayTextStyle(context).copyWith(color: AppColors.white);

    return CalendarStyle(
      outsideTextStyle: mutedText,
      todayDecoration: circleDecoration,
      defaultTextStyle: dayText,
      weekendTextStyle: dayText,
      cellMargin: EdgeInsets.all(1.5.w),
      rangeStartDecoration: circleDecoration,
      rangeEndDecoration: circleDecoration,
      withinRangeDecoration: circleDecoration,
      rangeStartTextStyle: circleText,
      rangeEndTextStyle: circleText,
      withinRangeTextStyle: circleText,
      rangeHighlightColor: Colors.transparent,
      isTodayHighlighted: isTodayHighlighted,
    );
  }

  TextStyle _dayTextStyle(BuildContext context) =>
      context.headlineLarge!.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        fontFamily: AppFonts.inter,
      );

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isPastDay(DateTime day) =>
      day.isBefore(_today) &&
      day.month == _today.month &&
      day.year == _today.year;
}

import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_fonts.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/calendar/custom_table_calendar.dart';
import 'package:disciple/widgets/calendar/module/calendar_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends ConsumerStatefulWidget {
  const CalendarWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends ConsumerState<CalendarWidget> {
  late PageController _pageController;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  TextStyle _dayTextStyle(BuildContext context) =>
      context.headlineLarge!.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        fontFamily: AppFonts.inter,
      );

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = _dayTextStyle(context);
    final calendarState = ref.watch(calendarProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (calendarState.calendarFrequency != CalendarFrequency.weekly) ...[
          _buildHeader(calendarState),
          SizedBox(height: 8.h),
        ],
        _buildCalendarContainer(baseTextStyle, calendarState),
      ],
    );
  }

  Widget _buildHeader(CalendarNotifier calendarState) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      IconButton(
        onPressed: _handlePreviousPage,
        icon: const Icon(Icons.navigate_before),
      ),
      Text(
        calendarState.focusedDay.monthYear,
        style: context.headlineLarge?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      IconButton(
        onPressed: _handleNextPage,
        icon: const Icon(Icons.navigate_next),
      ),
    ],
  );

  Widget _buildCalendarContainer(
    TextStyle baseTextStyle,
    CalendarNotifier calendarState,
  ) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    decoration: BoxDecoration(
      color: AppColors.purple100,
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          SizeTransition(sizeFactor: animation, child: child),
      child: calendarState.calendarFrequency == CalendarFrequency.weekly
          ? _buildWeekdays(baseTextStyle, calendarState)
          : CustomTableCalendar(
              calendarFormat: calendarState.calendarFormat,
              pageControllerCallback: (controller) =>
                  _pageController = controller,
              rangeSelectionMode: _rangeSelectionMode,
            ),
    ),
  );

  Row _buildWeekdays(TextStyle baseTextStyle, CalendarNotifier calendarState) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((
          weekday,
        ) {
          final isSelected = calendarState.weekDay == weekday;
          return GestureDetector(
            onTap: () =>
                ref.read(calendarProvider.notifier).setWeekDay(weekday),
            child: Container(
              height: 47.h,
              width: 47.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.purple : Colors.transparent,
              ),
              child: Text(
                weekday,
                style: baseTextStyle.copyWith(
                  color: isSelected ? AppColors.white : AppColors.grey800,
                ),
              ),
            ),
          );
        }).toList(),
      );

  Future<void> _handlePreviousPage() async {
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _handleNextPage() async {
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

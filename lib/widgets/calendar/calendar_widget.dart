import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_fonts.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/calendar/module/calendar_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends ConsumerStatefulWidget {
  const CalendarWidget({super.key, required this.frequency});

  final String frequency;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends ConsumerState<CalendarWidget> {
  late PageController _pageController;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  String? _weekDay;
  final DateTime _present = DateTime.now();

  // --- Helpers ---
  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isPastDay(DateTime day) =>
      day.isBefore(_today) &&
      day.month == _today.month &&
      day.year == _today.year;

  TextStyle _dayTextStyle(BuildContext context) =>
      context.headlineLarge!.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        fontFamily: AppFonts.inter,
      );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = _dayTextStyle(context);
    final calendarState = ref.watch(calendarProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (calendarState.calendarFrequency != CalendarFrequency.weekly) ...[
          _buildHeader(),
          SizedBox(height: 8.h),
        ],
        _buildCalendarContainer(baseTextStyle, calendarState),
      ],
    );
  }

  // --- UI Builders ---
  Widget _buildHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      IconButton(
        onPressed: _handlePreviousPage,
        icon: const Icon(Icons.navigate_before),
      ),
      Text(
        _focusedDay.monthYear,
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
          ? _buildWeekdays(baseTextStyle)
          : TableCalendar(
              firstDay: DateTime(_present.year, _present.month),
              lastDay: DateTime(_present.year + 5, _present.month, 0),
              focusedDay: _focusedDay,
              headerVisible: false,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onCalendarCreated: (controller) => _pageController = controller,
              calendarFormat: calendarState.calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              onPageChanged: (focusedDay) =>
                  setState(() => _focusedDay = focusedDay),
              // Disable past dates
              enabledDayPredicate: (day) => !_isPastDay(day),

              onDaySelected: (selectedDay, focusedDay) {
                if (_isPastDay(selectedDay)) return;
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onRangeSelected: (start, end, focusedDay) {
                if (start != null && _isPastDay(start)) return;
                setState(() {
                  _rangeStart = start;
                  _rangeEnd = end;
                  _focusedDay = focusedDay;
                });
              },
              daysOfWeekVisible:
                  calendarState.calendarFrequency != CalendarFrequency.monthly,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: baseTextStyle,
                weekendStyle: baseTextStyle,
              ),
              rangeSelectionMode: _rangeSelectionMode,
              daysOfWeekHeight: 50.h,
              calendarStyle: _calendarStyle(baseTextStyle),
            ),
    ),
  );

  Row _buildWeekdays(TextStyle baseTextStyle) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((weekday) {
      final isSelected = _weekDay == weekday;
      return GestureDetector(
        onTap: () => setState(() => _weekDay = weekday),
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

  CalendarStyle _calendarStyle(TextStyle baseTextStyle) {
    final mutedText = baseTextStyle.copyWith(
      color: AppColors.grey250,
      fontWeight: FontWeight.w400,
    );

    final dayText = baseTextStyle.copyWith(color: AppColors.grey800);

    const circleDecoration = BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.purple,
    );

    final circleText = baseTextStyle.copyWith(color: AppColors.white);

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
    );
  }

  // --- Navigation ---
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

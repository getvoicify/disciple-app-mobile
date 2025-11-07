import 'package:disciple/app/core/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:table_calendar/table_calendar.dart';

enum CalendarFrequency { daily, weekly, monthly }

final calendarProvider = ChangeNotifierProvider((ref) => CalendarNotifier());

class CalendarNotifier extends ChangeNotifier {
  // --- core state ---
  CalendarFormat _calendarFormat = CalendarFormat.week;
  CalendarFormat get calendarFormat => _calendarFormat;

  CalendarFrequency _calendarFrequency = CalendarFrequency.weekly;
  CalendarFrequency get calendarFrequency => _calendarFrequency;

  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? get rangeStart => _rangeStart;
  DateTime? get rangeEnd => _rangeEnd;

  DateTime _focusedDay = DateTime.now();
  DateTime get focusedDay => _focusedDay;

  DateTime? _selectedDay;
  DateTime? get selectedDay => _selectedDay;

  String? _weekDay;
  String? get weekDay => _weekDay;

  String _frequency = 'Weekly';
  String get frequency => _frequency;

  ReminderData? _reminder;
  ReminderData? get reminder => _reminder;

  // --- helpers ---
  static const Map<String, int> _weekdayMap = {
    "Mon": 1,
    "Tue": 2,
    "Wed": 3,
    "Thu": 4,
    "Fri": 5,
    "Sat": 6,
    "Sun": 7,
  };

  int _weekdayIndex(String day) => _weekdayMap[day] ?? 1;

  // --- API / setters ---

  void setCalendarFormat(String format, {bool notify = true}) {
    switch (format) {
      case "Daily":
        _calendarFrequency = CalendarFrequency.daily;
        _calendarFormat = CalendarFormat.month;
      case "Weekly":
        _calendarFrequency = CalendarFrequency.weekly;
        _calendarFormat = CalendarFormat.week;
      case "Monthly":
        _calendarFrequency = CalendarFrequency.monthly;
        _calendarFormat = CalendarFormat.month;
      default:
        return;
    }

    // resetting weekday selection when changing format
    _weekDay = null;
    _frequency = format;
    if (notify) notifyListeners();
  }

  void setRange(DateTime? start, DateTime? end) {
    if (_rangeStart == start && _rangeEnd == end) return;
    _rangeStart = start;
    _rangeEnd = end;
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    if (_focusedDay == day) return;
    _focusedDay = day;
    notifyListeners();
  }

  void setSelectedDay(DateTime? day) {
    if (_selectedDay == day) return;
    _selectedDay = day;
    notifyListeners();
  }

  void setWeekDay(String? day) {
    if (_weekDay == day) return;
    _weekDay = day;
    notifyListeners();
  }

  void setFrequency(String frequency) {
    if (_frequency == frequency) return;
    _frequency = frequency;
    notifyListeners();
  }

  /// Returns inclusive list of dates between rangeStart and rangeEnd.
  /// If rangeStart == null => empty list.
  /// If rangeEnd == null => single day list [rangeStart].
  List<DateTime> dateRange() {
    if (_rangeStart == null) return [];
    final start = DateTime(
      _rangeStart!.year,
      _rangeStart!.month,
      _rangeStart!.day,
    );
    final end = _rangeEnd == null
        ? start
        : DateTime(_rangeEnd!.year, _rangeEnd!.month, _rangeEnd!.day);

    final days = end.difference(start).inDays;
    if (days == 0) return [start];

    return List.generate(days + 1, (i) => start.add(Duration(days: i)));
  }

  /// Returns the next occurrence of the given weekday (Mon..Sun)
  /// with provided hour/minute. If the weekday is today, returns next week's day.
  DateTime nextWeekday({
    required String weekday,
    required int hour,
    required int minute,
  }) {
    final now = DateTime.now();
    final target = _weekdayIndex(weekday);

    int diff = (target - now.weekday) % 7;
    if (diff == 0) diff = 7; // next week if same weekday

    final next = now.add(Duration(days: diff));
    return DateTime(next.year, next.month, next.day, hour, minute);
  }

  void setOtherValues(ReminderData reminder) {
    // populate notifier state for edit mode
    _reminder = reminder;

    if (reminder.scheduledAt != null) {
      final dt = reminder.scheduledAt!;
      _rangeStart = DateTime(dt.year, dt.month, dt.day);
      _rangeEnd = _rangeStart;
      _selectedDay = _rangeStart;
      _focusedDay = _rangeStart!;
    } else {
      _rangeStart = null;
      _rangeEnd = null;
      _selectedDay = null;
    }

    // default frequency — if you store frequency/weekDay in DB later, set here
    _frequency = 'Daily';
    _calendarFrequency = CalendarFrequency.daily;
    _calendarFormat = CalendarFormat.month;

    notifyListeners();
  }

  /// reset to defaults
  void reset() {
    _calendarFrequency = CalendarFrequency.weekly;
    _calendarFormat = CalendarFormat.week;
    _rangeStart = null;
    _rangeEnd = null;
    _focusedDay = DateTime.now();
    _selectedDay = null;
    _weekDay = null;
    _frequency = 'Weekly';
    _reminder = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }
}

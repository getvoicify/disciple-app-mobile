import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:table_calendar/table_calendar.dart';

enum CalendarFrequency { daily, weekly, monthly }

final calendarProvider = ChangeNotifierProvider((ref) => CalendarNotifier());

class CalendarNotifier extends ChangeNotifier {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  CalendarFormat get calendarFormat => _calendarFormat;

  CalendarFrequency _calendarFrequency = CalendarFrequency.daily;
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

  String _frequency = 'Daily';
  String get frequency => _frequency;

  ReminderData? _reminder;
  ReminderData? get reminder => _reminder;

  void setCalendarFormat(String format) {
    switch (format) {
      case "Daily":
        _calendarFrequency = CalendarFrequency.daily;
        _weekDay = null;
        _calendarFormat = CalendarFormat.month;
      case "Weekly":
        _weekDay = null;
        _calendarFrequency = CalendarFrequency.weekly;
        _calendarFormat = CalendarFormat.week;
      case "Monthly":
        _weekDay = null;
        _calendarFrequency = CalendarFrequency.monthly;
        _calendarFormat = CalendarFormat.month;
      default:
    }
    notifyListeners();
  }

  void setRange(DateTime? start, DateTime? end) {
    _rangeStart = start;
    _rangeEnd = end;
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void setSelectedDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  List<DateTime> dateRange() {
    final List<DateTime> dates = [];

    if (rangeStart == null) return dates;

    // If no rangeEnd is provided, just return the single date
    final end = rangeEnd ?? rangeStart!;

    // Add all dates from start to end inclusive
    for (
      DateTime date = rangeStart!;
      date.isBefore(end) || date.isAtSameMomentAs(end);
      date = date.add(const Duration(days: 1))
    ) {
      dates.add(date);
    }

    return dates;
  }

  DateTime nextWeekday({
    required String weekday,
    required int hour,
    required int minute,
  }) {
    final now = DateTime.now();
    final targetIndex = _weekdayIndex(weekday); // Mon = 1 ... Sun = 7

    return DateTime(now.year, now.month, targetIndex, hour, minute);
  }

  int _weekdayIndex(String day) {
    const days = {
      "Mon": 1,
      "Tue": 2,
      "Wed": 3,
      "Thu": 4,
      "Fri": 5,
      "Sat": 6,
      "Sun": 7,
    };

    return days[day] ?? 1; // default Monday
  }

  void setWeekDay(String day) {
    _weekDay = day;
    notifyListeners();
  }

  void setFrequency(String frequency) {
    _frequency = frequency;
    notifyListeners();
  }

  void reset() {
    _calendarFrequency = CalendarFrequency.daily;
    _calendarFormat = CalendarFormat.month;
    _rangeStart = null;
    _rangeEnd = null;
    _focusedDay = DateTime.now();
    _selectedDay = null;
    _weekDay = null;
    _frequency = 'Daily';
    _reminder = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void setOtherValues(ReminderData reminder) {
    _rangeStart = reminder.scheduledAt;
    _rangeEnd = reminder.scheduledAt;
    _reminder = reminder;
    _frequency = 'Daily';
    _calendarFrequency = CalendarFrequency.daily;
    _calendarFormat = CalendarFormat.month;
    notifyListeners();
  }
}

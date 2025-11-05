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

  void setCalendarFormat(String format) {
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

  void setWeekDay(String day) {
    _weekDay = day;
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
    notifyListeners();
  }
}

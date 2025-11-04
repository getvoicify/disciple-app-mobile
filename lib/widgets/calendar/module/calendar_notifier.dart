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
}

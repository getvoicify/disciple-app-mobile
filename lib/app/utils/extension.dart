import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import '../core/theme/provider/theme_provider.dart';

enum InputType { none, email, phone }

extension StringExtensions on String {
  String get tenWords => split(' ').take(10).join(' ');

  int parseAmount() => int.parse(replaceAll(',', '').replaceAll('.00', ''));

  bool get isNull => toLowerCase() == 'null';

  String get capitalizeFirst => isEmpty ? '' : this[0].toUpperCase();

  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String get titleCase => replaceAll(
    RegExp(' +'),
    ' ',
  ).split(' ').map((str) => str.toCapitalized).join(' ');

  String get removeUnderscore => replaceAll('_', ' ');
  String get removeDoubleZeros => replaceAll('.00', ' ');

  String get removeHyphen => replaceAll('-', ' ');

  String get removeAtcharacter => replaceAll('@', '');

  String _formatPhoneNumber(num phoneNumber) {
    final String phoneNumberStr = phoneNumber.toString();

    if (phoneNumberStr.length != 10) {
      throw ArgumentError("Phone number must have 10 digits");
    }

    return "(${phoneNumberStr.substring(0, 3)}) ${phoneNumberStr.substring(3, 6)} - ${phoneNumberStr.substring(6)}";
  }

  String get formattedPhoneNumber => _formatPhoneNumber(num.parse(this));

  String _reverseFormatPhoneNumber(String formattedPhoneNumber) {
    final String phoneNumberDigits = formattedPhoneNumber.replaceAll(
      RegExp(r'\D'),
      '',
    );

    if (phoneNumberDigits.length != 10) {
      throw ArgumentError("Invalid formatted phone number");
    }

    return phoneNumberDigits;
  }

  String get reversedFormattedPhoneNumber => _reverseFormatPhoneNumber(this);

  String get naira => _formatMoney('\u20A6');
  String get dollar => _formatMoney('\$');

  String _formatMoney(String symbol) {
    final double amount = double.tryParse(replaceAll('.', '')) ?? 0.0;

    final NumberFormat formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: symbol,
    );

    final String formattedAmount = formatter.format(amount / 100);

    return formattedAmount;
  }

  String get formatCountryCode => replaceAll('+234', '0').replaceAll(' ', '');

  num get replaceComma => num.tryParse(replaceAll(',', '')) ?? 0;

  num get toNum => num.tryParse(this) ?? 0;

  InputType get inputType {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    final RegExp phoneRegExp = RegExp(r'^\+?[\d\s]{3,}$');

    if (emailRegExp.hasMatch(this)) {
      return InputType.email;
    } else if (phoneRegExp.hasMatch(this)) {
      return InputType.phone;
    } else {
      return InputType.none;
    }
  }
}

extension CurrencyExtensions on num {
  String get toNaira => NumberFormat.simpleCurrency(name: 'NGN').format(this);
  String get toDirham => 'AED ${NumberFormat('#,##0.00').format(this)}';

  String get toNairaWithOutSymbol =>
      NumberFormat.simpleCurrency(name: '', decimalDigits: 2).format(this);
  String get ordinals => _getJustOrdinalIndicator(this);

  String _getJustOrdinalIndicator(num number) {
    String suffix = 'th';
    final num digit = number % 10;
    if ((digit > 0 && digit < 4) && (number < 11 || number > 13)) {
      suffix = <String>['st', 'nd', 'rd'][int.parse(digit.toString()) - 1];
    }
    return '$number$suffix';
  }

  String pluralize(String text) => Intl.plural(
    this,
    zero: text,
    one: '$this $text',
    other: '$this ${text}s',
  );
}

extension DateTimeExtensions on DateTime {
  String get toTime => DateFormat('hh:mm a').format(this);
  DateTime get dateOnly => DateTime(year, month, day);

  String get dateFormatter => 'MMMM dd, y';
  String get monthYear => DateFormat('MMMM yyyy').format(this);

  String get dateAndMonth => DateFormat('dd MMM').format(this);

  String get dow => DateFormat('EEE').format(this);

  DateTime get firstDayOfMonth => DateTime(year, month);

  DateTime get lastDayOfMonth => DateTime(year, month + 1, 0);

  int get getTotalDays {
    // Get the last day of the month
    final int totalDays = DateTime(year, month + 1, 0).day;
    // Nights are one less than the total days
    return totalDays;
  }

  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }

  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  String get months => DateFormat('MMMM').format(this);

  String get dateMonth => DateFormat('dd MMM').format(this);
  String get monthDate => DateFormat('MMM dd').format(this);

  String get monthTime => DateFormat('MMM dd, yyyy | hh:mm a').format(this);

  String get monthDateYear => DateFormat('MMM dd, yyyy').format(this);
  String get monthDateYearTime =>
      DateFormat('MMM dd, yyyy - hh:mm a').format(this);

  String get dayMonthYear => DateFormat('dd MMM yyyy').format(this);
  String get dayMonthYearWithSlash => DateFormat('dd/MM/yyyy').format(this);

  String get yearMonthDay => DateFormat('yyyy-MM-dd').format(this);
  String get yearMonthDayTime =>
      DateFormat('yyyy-MM-dd - hh:mm a').format(this);
  String get dateMonthYearHyphen => DateFormat('dd-MM-yyyy').format(this);

  String get timeAloneWithMeridian12 => DateFormat('hh:mm a').format(this);

  String get timeAloneWithMeridian24 => DateFormat('HH:mm a').format(this);

  String get getWeekday => DateFormat('EEE').format(this);

  String get countTime =>
      DateFormat('EEE, dd MMM, yyyy - hh:mm a').format(this);

  String get dayMonthTime => DateFormat('dd MMM, hh:mm a').format(this);
  String get dayMonthTime1 => DateFormat('hh:mm a, MMM dd, yyyy').format(this);

  String get monthDayYear => DateFormat('MMM, dd, yyyy').format(this);
  String get dateMonthYear => DateFormat('dd MMM yyyy').format(this);
  String get dateMonthYearTime =>
      DateFormat('dd MMM yyyy - hh:mm a').format(this);

  DateTime get toDateOnly => DateTime(year, month, day);

  String get dateMonthYearTime1 =>
      DateFormat("MMM dd, yyyy 'at' hh:mm a").format(this);

  String get monthDayTime => DateFormat('MMM dd, hh:mm a').format(this);

  String get getFullMonth => DateFormat('MMMM').format(this);

  String get getAbbrMonth => DateFormat('MMM').format(this);

  String get getFullYear => DateFormat('yyyy').format(this);

  String get dateWithHyphen => DateFormat('yyyy-MM-dd').format(this);

  String get monthDateYearOrdinals => _getOrdinalIndicator(this);

  String _getOrdinalIndicator(DateTime dateTime) {
    String suffix = 'th';
    final int digit = dateTime.day % 10;
    if ((digit > 0 && digit < 4) && (dateTime.day < 11 || dateTime.day > 13)) {
      suffix = <String>['st', 'nd', 'rd'][digit - 1];
    }
    return DateFormat("MMMM d'$suffix' y").format(dateTime);
  }
}

extension FileExtensions on File {
  String get fileSize {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    final int sizeInBytes = lengthSync();
    if (sizeInBytes == 0) return '0${suffixes[0]}';
    final int i = (log(sizeInBytes) / log(1024)).floor();
    return ((sizeInBytes / pow(1024, i)).toStringAsFixed(0)) + suffixes[i];
  }

  String get fileExtension => path.split('.').last;

  String get fileName => path.split('/').last;
}

extension ContextExtensions on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width <= 500.0;

  bool get isTablet =>
      MediaQuery.of(this).size.width < 1024.0 &&
      MediaQuery.of(this).size.width >= 650.0;

  bool get isSmallTablet =>
      MediaQuery.of(this).size.width < 650.0 &&
      MediaQuery.of(this).size.width > 500.0;

  bool get isDesktop => MediaQuery.of(this).size.width >= 1024.0;

  bool get isSmall =>
      MediaQuery.of(this).size.width < 850.0 &&
      MediaQuery.of(this).size.width >= 560.0;

  bool get isKeyboardUp => MediaQuery.of(this).viewInsets.bottom > 0;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  double get bottom => MediaQuery.of(this).viewInsets.bottom;

  Size get size => MediaQuery.of(this).size;

  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;

  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;

  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge;

  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;

  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;

  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;

  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;

  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;
  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;

  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;

  TextStyle? get titleTextStyle => Theme.of(this).appBarTheme.titleTextStyle;

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  TextStyle? get bodyExtraSmall =>
      bodySmall?.copyWith(fontSize: 10, height: 1.6, letterSpacing: .5);

  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;

  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;

  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;

  TextStyle? get dividerTextSmall => bodySmall?.copyWith(
    letterSpacing: 0.5,
    fontWeight: FontWeight.w700,
    fontSize: 12.0,
  );

  WidgetStateProperty<Color?>? get buttonBackgroundColor =>
      Theme.of(this).elevatedButtonTheme.style?.backgroundColor;

  Color? get divider => Theme.of(this).dividerTheme.color;

  Color? get bottomNavigationBackgroundColor =>
      Theme.of(this).bottomNavigationBarTheme.backgroundColor;

  TabBarThemeData? get tabBarTheme => Theme.of(this).tabBarTheme;

  TextStyle? get dividerTextLarge => bodySmall?.copyWith(
    letterSpacing: 1.5,
    fontWeight: FontWeight.w700,
    fontSize: 13.0,
    height: 1.23,
  );

  ThemeData get theme => Theme.of(this);

  Color get primaryColor => Theme.of(this).primaryColor;

  Color get primaryColorDark => Theme.of(this).primaryColorDark;

  Color get primaryColorLight => Theme.of(this).primaryColorLight;

  Color get primary => Theme.of(this).colorScheme.primary;

  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  Color get secondary => Theme.of(this).colorScheme.secondary;

  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;
  Color get onSurface => Theme.of(this).colorScheme.onSurface;

  Color get cardColor => Theme.of(this).cardColor;
  BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      Theme.of(this).bottomNavigationBarTheme;

  Color get errorColor => Theme.of(this).colorScheme.error;
  InputDecorationThemeData get inputDecorationTheme =>
      Theme.of(this).inputDecorationTheme;

  Color get background => Theme.of(this).colorScheme.surface;
  BottomSheetThemeData? get bottomSheetTheme => Theme.of(this).bottomSheetTheme;

  Color? get dragHandleColor => Theme.of(this).bottomSheetTheme.dragHandleColor;

  void nextFocus([FocusNode? node]) => FocusScope.of(this).requestFocus(node);
  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) =>
      FocusScope.of(this).unfocus();

  void dismissTrey() => OverlaySupportEntry.of(this)!.dismiss();

  FilteringTextInputFormatter get charactersOnly =>
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));

  LengthLimitingTextInputFormatter limit({int max = 11}) =>
      LengthLimitingTextInputFormatter(max);

  TextInputFormatter get digitsOnly => FilteringTextInputFormatter.digitsOnly;

  Future<dynamic> navigateTo1(String route) async {}

  void replaceNamed(String route, {Object? arguments}) {}
}

extension DynamicMapExtension on Map<dynamic, dynamic> {
  Map<String, dynamic> convertToTypedMap() {
    final Map<String, dynamic> typedMap = {};

    forEach((key, value) {
      if (key is String) {
        typedMap[key] = value;
      } else {
        typedMap[key.toString()] = value;
      }
    });

    return typedMap;
  }
}

extension RefExtension on WidgetRef {
  // Get system brightness using SchedulerBinding
  Brightness get _brightness =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  // Get the current ThemeMode from the provider
  ThemeMode get _themeMode => watch(themeProvider).themeMode;

  // Determine if the app is in light mode considering system brightness
  bool get isLightMode =>
      _themeMode == ThemeMode.light ||
      (_themeMode == ThemeMode.system && _brightness == Brightness.light);

  // Determine if the app is in dark mode considering system brightness
  bool get isDarkMode =>
      _themeMode == ThemeMode.dark ||
      (_themeMode == ThemeMode.system && _brightness == Brightness.dark);

  void reset() {}
}

extension MapConverter on Map<String, dynamic>? {
  Map<String, Object>? toObjectMap() {
    if (this == null) return null;

    return Map<String, Object>.fromEntries(
      this!.entries
          .where((entry) => entry.value is Object)
          .map(
            (entry) => MapEntry(entry.key.toString(), entry.value.toString()),
          ),
    );
  }
}

import 'dart:io';
import 'dart:math';

import 'package:disciple/app/core/database/module/app_database_module.dart';
import 'package:disciple/app/core/manager/connectivity_manager.dart';
import 'package:disciple/features/authentication/services/keycloak_service.dart';
import 'package:disciple/features/bible/data/mapper/module/module.dart';
import 'package:disciple/features/notes/data/mapper/module/module.dart';
import 'package:disciple/features/notes/data/resync/module/module.dart';
import 'package:disciple/features/notes/data/source_impl/module/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:disciple/app/core/theme/provider/theme_provider.dart';

extension DateTimeExtensions on DateTime {
  String get monthTime => DateFormat('MMM dd, yyyy | hh:mm a').format(this);

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return DateFormat('dd/MM/yyyy').format(this);
    } else if (difference.inDays >= 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays >= 7) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
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

  String greetings(String name) {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Goodmorning $name";
    } else if (hour >= 12 && hour < 17) {
      return "Goodafternoon $name";
    } else if (hour >= 17 && hour < 21) {
      return "Goodevening $name";
    } else {
      return "Goodnight $name";
    }
  }
}

extension RefExtension on Ref {
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

  bool get isloggedIn =>
      watch(keycloakServiceProvider).value?.isAuthenticated ?? false;

  void reset() {
    invalidate(noteSourceModule);
    invalidate(noteToCompanionMapperProvider);
    invalidate(appDatabaseProvider);
    invalidate(syncManagerProvider);
    invalidate(connectivityManagerInstanceProvider);
    invalidate(bibleToCompanionMapperProvider);
  }
}

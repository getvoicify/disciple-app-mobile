import 'package:disciple/app/core/theme/dark_theme.dart';
import 'package:disciple/app/core/theme/light_theme.dart';
import 'package:disciple/features/notes/presentation/views/new_notes_view.dart';
import 'package:disciple/features/notes/presentation/views/notes_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ScreenUtilInit(
    designSize: const Size(430, 932),
    minTextAdapt: true,
    builder: (context, child) => MaterialApp(
      title: 'Disciple',
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: const NotesView(),
    ),
  );
}

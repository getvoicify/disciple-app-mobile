import 'package:disciple/app/config/app_config.dart';
import 'package:disciple/app/core/routes/app_router.dart';
import 'package:disciple/app/core/theme/dark_theme.dart';
import 'package:disciple/app/core/theme/light_theme.dart';
import 'package:disciple/features/authentication/services/keycloak_service.dart';
import 'package:disciple/features/notes/data/resync/module/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  const envString = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  switch (envString) {
    case 'development':
      AppConfig.setAppEnv(AppEnv.development);
    case 'production':
      AppConfig.setAppEnv(AppEnv.production);
  }

  await dotenv.load(fileName: AppConfig.fileName);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly initialize the network manager to start listening on app startup.
    ref.watch(syncManagerProvider);

    final keycloakService = ref.watch(keycloakServiceProvider);

    return keycloakService.when(
      data: (service) {
        final appRouter = AppRouter(keycloakService: service);
        return ScreenUtilInit(
          designSize: const Size(430, 932),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp.router(
            title: AppConfig.appName,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter.config(),
          ),
        );
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const MaterialApp(home: Scaffold()),
    );
  }
}

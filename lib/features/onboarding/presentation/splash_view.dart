import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/features/bible/presentation/notifier/bible_notifier.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(bibleProvider.notifier).importBibles().whenComplete(() async {
        await PageNavigator.replace(const DashboardRoute());
      });
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: ImageWidget(
      width: double.infinity,
      height: double.infinity,
      imageUrl: AppImage.onboarding,
      fit: BoxFit.cover,
    ),
  );
}

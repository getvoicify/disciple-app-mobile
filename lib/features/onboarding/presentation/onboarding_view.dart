<<<<<<< HEAD
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
=======
import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/core/manager/keycloak_manager.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:disciple/widgets/mini_button_widget.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeboardingView extends StatefulWidget {
  const HomeboardingView({super.key});

  @override
  State<HomeboardingView> createState() => _HomeboardingViewState();
}

class _HomeboardingViewState extends State<HomeboardingView> {
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class HomeboardingView extends ConsumerStatefulWidget {
  const HomeboardingView({super.key});

  @override
  ConsumerState<HomeboardingView> createState() => _HomeboardingViewState();
}

class _HomeboardingViewState extends ConsumerState<HomeboardingView> {
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
  late List<String> _images;

  @override
  void initState() {
    _images = [
      AppImage.onboarding1,
      AppImage.onboarding2,
      AppImage.onboarding3,
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: Stack(
      children: [
        PageView.builder(
          itemCount: _images.length,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.only(left: 66.w),
            alignment: Alignment.bottomRight,
            child: ImageWidget(imageUrl: _images[index]),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRichText(title: "Grow ", subtitle: "deeper."),
              SizedBox(height: 8.h),
              _buildRichText(title: "Connect ", subtitle: "stronger."),
              SizedBox(height: 8.h),
              _buildRichText(title: "Live ", subtitle: "intentionally."),
              SizedBox(height: 12.h),
              Text(
                'Discover faith-building tools, devotionals, and a thriving community—all in one place.',
                style: context.bodyLarge,
              ),
              SizedBox(height: 30.h),
<<<<<<< HEAD
              MiniButtonWidget(title: AppString.getStarted),
=======
              MiniButtonWidget(title: AppString.getStarted, onTap: _login),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
            ],
          ),
        ),
      ],
    ),
  );

  RichText _buildRichText({required String title, required String subtitle}) =>
      RichText(
        text: TextSpan(
          text: title,
          style: context.headlineLarge,
          children: [TextSpan(text: subtitle, style: context.headlineMedium)],
        ),
      );
<<<<<<< HEAD
=======

  Future<void> _login() async {
    final success = await ref.read(keycloakManagerProvider).value?.login();
    if (success != null && success) {
      PageNavigator.replace(const DashboardRoute());
    }
  }
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}

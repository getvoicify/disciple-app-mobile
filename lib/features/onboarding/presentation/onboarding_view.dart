import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:disciple/widgets/mini_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeboardingView extends StatefulWidget {
  const HomeboardingView({super.key});

  @override
  State<HomeboardingView> createState() => _HomeboardingViewState();
}

class _HomeboardingViewState extends State<HomeboardingView> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          PageView.builder(
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(left: 66.w),
                alignment: Alignment.bottomRight,
                child: ImageWidget(imageUrl: _images[index]),
              );
            },
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
                MiniButtonWidget(title: AppString.getStarted),
              ],
            ),
          ),
        ],
      ),
    );
  }

  RichText _buildRichText({required String title, required String subtitle}) {
    return RichText(
      text: TextSpan(
        text: title,
        style: context.headlineLarge,
        children: [TextSpan(text: subtitle, style: context.headlineMedium)],
      ),
    );
  }
}

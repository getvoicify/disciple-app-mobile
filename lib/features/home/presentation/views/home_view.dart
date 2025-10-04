import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_fonts.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/config/app_helper.dart';
import 'package:disciple/app/core/manager/keycloak_manager.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/bible/presentation/notifier/bible_notifier.dart';
import 'package:disciple/widgets/action_button_widget.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:disciple/widgets/mini_button_widget.dart';
import 'package:disciple/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late BibleNotifier _bibleNotifier;
  final GlobalKey _shareKey = GlobalKey();
  bool _hideActionsForCapture = false;

  @override
  void initState() {
    super.initState();
    _bibleNotifier = ref.read(bibleProvider.notifier);
    unawaited(_bibleNotifier.getDailyScripture());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(keycloakManagerProvider).value?.user;
    final dailyScripture = ref.watch(bibleProvider).dailyScripture;
    final String scripture =
        '${dailyScripture?.bookName} ${dailyScripture?.chapter}:${dailyScripture?.verse} ${(dailyScripture?.versionId ?? '').toUpperCase()}';
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.feed),
        centerTitle: false,
        actions: [
          const ImageWidget(imageUrl: AppImage.notificationIcon),
          SizedBox(width: 16.w),
          const ProfileImageWidget(),
          SizedBox(width: 16.w),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: ListView(
          children: [
            Text(
              context.greetings(user?.givenName ?? ''),
              style: context.bodyMedium?.copyWith(
                fontSize: 16.sp,
                color: AppColors.grey100,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5.sp,
                fontFamily: AppFonts.literata,
              ),
            ),
            SizedBox(height: 26.h),

            RepaintBoundary(
              key: _shareKey,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: const DecorationImage(
                    image: AssetImage(AppImage.gradient),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.dailyScripture,
                      style: context.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      scripture,
                      style: context.headlineLarge?.copyWith(fontSize: 16.sp),
                    ),
                    SizedBox(height: 64.h),
                    Text(
                      dailyScripture?.verseText ?? '',
                      style: context.bodyLarge?.copyWith(
                        fontSize: 16.sp,
                        fontFamily: AppFonts.literata,
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Offstage(
                      offstage: _hideActionsForCapture,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 28.w,
                            vertical: 9.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.grey50,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey100.withValues(
                                  alpha: 0.10,
                                ),
                                blurRadius: 4.r,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 32.w,
                            children: [
                              const ActionButtonWidget(icon: AppImage.likeIcon),
                              ActionButtonWidget(
                                icon: AppImage.shareIcon,
                                onTap: () => _shareScriptureImage(),
                              ),
                              const ActionButtonWidget(
                                icon: AppImage.expandIcon,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            Container(
              height: 225.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: const DecorationImage(
                  image: AssetImage(AppImage.devotionalsImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                alignment: Alignment.bottomLeft,
                child: MiniButtonWidget(title: AppString.devotionals),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Reminders',
                    style: context.headlineLarge?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'All Reminders',
                        style: context.headlineMedium?.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.purple,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    const ImageWidget(imageUrl: AppImage.arrowRightIcon),
                  ],
                ),
              ],
            ),
            SizedBox(height: 19.h),
            Row(
              children: [
                Expanded(
                  child: _buildQuickLinksWidget(
                    title: 'Family Prayer',
                    date: 'Family Prayer',
                    time: '6:00AM',
                    color: AppColors.green50,
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: _buildQuickLinksWidget(
                    title: 'Weekly Prayer',
                    date: 'Tomorrow',
                    time: '6:00AM',
                    color: AppColors.red50,
                  ),
                ),
              ],
            ),

            SizedBox(height: 19.h),
            Row(
              children: [
                Expanded(
                  child: _buildQuickLinksWidget(
                    title: 'Peniel Hour',
                    date: 'Tomorrow',
                    time: '6:00AM',
                    color: AppColors.blueLight50,
                    borderColor: AppColors.grey200,
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: _buildQuickLinksWidget(
                    title: 'Home Church',
                    date: 'Saturday',
                    time: '6:00AM',
                    color: AppColors.indigo,
                    borderColor: AppColors.grey200,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildQuickLinksWidget({
    required String title,
    required String date,
    required String time,
    required Color color,
    Color? borderColor,
  }) => Container(
    padding: EdgeInsets.only(left: 20.w, top: 20.h, right: 20.w, bottom: 17.h),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      color: color,
      border: Border.all(color: borderColor ?? Colors.transparent),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.headlineLarge?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(date, style: context.headlineMedium?.copyWith(fontSize: 12.sp)),
        SizedBox(height: 15.h),
        Row(
          children: [
            const ImageWidget(imageUrl: AppImage.clockIcon),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                time,
                style: context.headlineMedium?.copyWith(fontSize: 12.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 6.w),
            const ImageWidget(imageUrl: AppImage.forwardIcon),
          ],
        ),
      ],
    ),
  );

  Future<void> _shareScriptureImage() async {
    setState(() => _hideActionsForCapture = true);

    // Give Flutter a frame to rebuild without actions
    await Future.delayed(const Duration(milliseconds: 50));

    final bytes = await AppHelper.captureWidget(_shareKey);

    setState(() => _hideActionsForCapture = false); // restore buttons

    if (bytes != null) {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/daily_scripture.png').create();
      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: "Today's Scripture 📖"),
      );
    }
  }
}

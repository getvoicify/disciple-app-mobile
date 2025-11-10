import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_fonts.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/config/app_helper.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/manager/keycloak_manager.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/bible/presentation/notifier/bible_notifier.dart';
import 'package:disciple/features/reminder/presentation/notifier/reminder_notifier.dart';
import 'package:disciple/widgets/action_button_widget.dart';
import 'package:disciple/widgets/calendar/module/calendar_notifier.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:disciple/widgets/mini_button_widget.dart';
import 'package:disciple/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

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
  bool _isExpanded = false;

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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubic,
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: const DecorationImage(
                    image: AssetImage(AppImage.gradient),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Cancel icon fade in ---
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeInOutCubic,
                        switchOutCurve: Curves.easeInOutCubic,
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            child: child,
                          ),
                        ),
                        child: !_isExpanded
                            ? const SizedBox.shrink()
                            : Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _isExpanded = false),
                                  child: AnimatedPadding(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOutCubic,
                                    padding: EdgeInsets.only(
                                      bottom: _isExpanded ? 16.h : 0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const ImageWidget(
                                          imageUrl: AppImage.cancelIcon,
                                        ),
                                        AnimatedSize(
                                          duration: const Duration(
                                            milliseconds: 400,
                                          ),
                                          curve: Curves.easeInOutCubic,
                                          child: SizedBox(
                                            height: _isExpanded ? 119.h : 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ),

                      // --- Title + Reference ---
                      Text(
                        AppString.dailyScripture,
                        style: context.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        scripture,
                        style: context.headlineLarge?.copyWith(fontSize: 16.sp),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutCubic,
                        child: SizedBox(height: _isExpanded ? 20.h : 40.h),
                      ),

                      // --- Animated verse text ---
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: _isExpanded ? 16.sp : 32.sp,
                          end: _isExpanded ? 32.sp : 16.sp,
                        ),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                        builder: (context, animatedFontSize, child) => Text(
                          dailyScripture?.verseText ?? '',
                          textAlign: TextAlign.start,
                          style: context.bodyLarge!.copyWith(
                            fontSize: animatedFontSize,
                            fontFamily: AppFonts.literata,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      // --- Animated spacing ---
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutCubic,
                        height: _isExpanded ? 120.h : 24.h,
                      ),

                      // --- Action buttons fade in/out smoothly ---
                      AnimatedOpacity(
                        opacity: _hideActionsForCapture ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        child: Center(
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
                                const ActionButtonWidget(
                                  icon: AppImage.likeIcon2,
                                ),
                                ActionButtonWidget(
                                  icon: AppImage.shareIcon,
                                  onTap: () => _shareScriptureImage(),
                                ),
                                if (!_isExpanded)
                                  ActionButtonWidget(
                                    icon: AppImage.expandIcon,
                                    onTap: () =>
                                        setState(() => _isExpanded = true),
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

            _buildRemindersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRemindersList() {
    final stream = ref
        .read(reminderProvider.notifier)
        .watchReminder(status: true);

    return StreamBuilder<List<ReminderData>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) return const SizedBox.shrink();

        final reminders = items.take(4).toList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                      child: GestureDetector(
                        onTap: () =>
                            PageNavigator.pushRoute(const AllRemindersRoute()),
                        child: Text(
                          'All Reminders',
                          style: context.headlineMedium?.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.purple,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    const ImageWidget(imageUrl: AppImage.arrowRightIcon),
                  ],
                ),
              ],
            ),
            SizedBox(height: 19.h),

            GridView.builder(
              itemCount: reminders.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                final reminder = reminders[index];
                return _buildQuickLinksWidget(
                  reminder: reminder,
                  onTap: () async {
                    ref
                        .read(calendarProvider.notifier)
                        .setOtherValues(reminder);
                    await PageNavigator.pushRoute(const CreateReminderRoute());
                  },
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20.h,
                crossAxisSpacing: 24.w,
                mainAxisExtent: 120.h,
              ),
            ),
          ],
        );
      },
    );
  }

  GestureDetector _buildQuickLinksWidget({
    required ReminderData reminder,
    required void Function() onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.only(
        left: 20.w,
        top: 20.h,
        right: 20.w,
        bottom: 17.h,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: reminder.colorValue?.toColor ?? Colors.transparent,
        border: Border.all(color: AppColors.grey200, width: 1.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reminder.title ?? '',
            style: context.headlineLarge?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            reminder.title ?? '',
            style: context.headlineMedium?.copyWith(fontSize: 12.sp),
            maxLines: 1,
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              const ImageWidget(imageUrl: AppImage.clockIcon),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  reminder.scheduledAt?.time ?? '',
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

      /// TODO: Share the file
      // await SharePlus.instance.share(
      //   ShareParams(files: [XFile(file.path)], text: "Today's Scripture 📖"),
      // );
    }
  }
}

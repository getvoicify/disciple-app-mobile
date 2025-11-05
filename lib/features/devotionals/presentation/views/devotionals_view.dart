import 'package:dio/dio.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/devotionals/presentation/notifier/devotional_notifier.dart';
import 'package:disciple/features/devotionals/presentation/views/skeleton/devotional_skeleton.dart';
import 'package:disciple/features/devotionals/presentation/widget/devotional_widget.dart';
import 'package:disciple/widgets/back_arrow_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class DevotionalsView extends ConsumerStatefulWidget {
  const DevotionalsView({super.key});

  @override
  ConsumerState<DevotionalsView> createState() => _DevotionalsViewState();
}

class _DevotionalsViewState extends ConsumerState<DevotionalsView> {
  late DevotionalNotifier _devotionalNotifier;
  final CancelToken _cancelToken = CancelToken();

  @override
  void initState() {
    _devotionalNotifier = ref.read(devotionalProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _devotionalNotifier.getDevotionals(
        date: DateTime(2024, 01, 16),
        cancelToken: _cancelToken,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Devotionals'),
      leading: const BackArrowWidget(),
      actions: [
        const ImageWidget(imageUrl: AppImage.menuIcon),
        SizedBox(width: 16.w),
      ],
    ),
    body: SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          const EditTextFieldWidget(
            prefix: ImageWidget(
              imageUrl: AppImage.searchIcon,
              fit: BoxFit.none,
            ),
            label: 'Search devotional',
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Text(
                  'All',
                  style: context.headlineLarge?.copyWith(
                    fontSize: 20.sp,
                    color: AppColors.purple,
                  ),
                ),
                SizedBox(width: 48.w),
                Text(
                  'Favorites',
                  style: context.headlineLarge?.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.grey700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),

          Consumer(
            builder: (_, ref, _) {
              final state = ref.watch(devotionalProvider);
              return Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: state.isLoadingDevotionals
                      ? const DevotionalSkeletonList()
                      : ListView.separated(
                          itemCount: state.devotionals.length,
                          itemBuilder: (_, index) => DevotionalWidget(
                            devotional: state.devotionals[index],
                          ),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 20.h),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

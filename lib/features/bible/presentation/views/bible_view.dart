import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/features/bible/presentation/widget/build_chapter_widget.dart';
import 'package:disciple/widgets/build_audio_controller_widget.dart';
import 'package:disciple/widgets/drop_down_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BibleView extends StatefulWidget {
  const BibleView({super.key});

  @override
  State<BibleView> createState() => _BibleViewState();
}

class _BibleViewState extends State<BibleView> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Bible'),
      actions: [
        const ImageWidget(imageUrl: AppImage.menuIcon),
        SizedBox(width: 16.w),
      ],
    ),
    body: SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        children: [
          ListView(
            children: [
              const EditTextFieldWidget(
                prefix: ImageWidget(
                  imageUrl: AppImage.searchIcon,
                  fit: BoxFit.none,
                ),
                label: 'Search scripture by words',
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 49.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BuildDropdownWidget(title: 'KJV'),
                    SizedBox(height: 16.h),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BuildDropdownWidget(title: 'Book'),
                        BuildDropdownWidget(title: 'Chapter'),
                        BuildDropdownWidget(title: 'Verse'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 31.h),
              ...List.generate(10, (index) {
                final bool isFirst = index == 0;
                final bool isLast = index == 9;
                return BuildChapterWidget(isFirst: isFirst, isLast: isLast);
              }),
            ],
          ),
          const BuildAudioControllerWidget(),
        ],
      ),
    ),
  );
}

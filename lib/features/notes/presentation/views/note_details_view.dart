import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoteDetailsView extends StatefulWidget {
  const NoteDetailsView({super.key});

  @override
  State<NoteDetailsView> createState() => _NoteDetailsViewState();
}

class _NoteDetailsViewState extends State<NoteDetailsView> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
      actions: [
        const ImageWidget(imageUrl: AppImage.dotsIcon),
        SizedBox(width: 16.w),
      ],
    ),
    body: ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Power From  Above',
                style: context.headlineLarge?.copyWith(fontSize: 24.sp),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Created: Yesterday',
                    style: context.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Last Edited: ---',
                    style: context.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),

        const Divider(color: AppColors.purple, thickness: 2),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.grey50,
                  border: Border.all(color: AppColors.grey300, width: .5.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ["Isa 4:19", "Mk 10:10", "1 Jn 4:7-8", "Deut 28:3"]
                      .map(
                        (chapter) => Expanded(
                          child: Text(
                            chapter,
                            style: context.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 21.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.grey50,
                  border: Border.all(color: AppColors.grey300, width: .5.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forem ipsum dolor sit amet',
                      style: context.headlineLarge?.copyWith(fontSize: 16.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Sorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nVorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.',
                      style: context.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

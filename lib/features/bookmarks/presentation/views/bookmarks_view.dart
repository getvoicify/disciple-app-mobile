import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/build_tile_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarksView extends StatefulWidget {
  const BookmarksView({super.key});

  @override
  State<BookmarksView> createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
        actions: [
          ImageWidget(imageUrl: AppImage.menuIcon),
          SizedBox(width: 16.w),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            EditTextFieldWidget(
              prefix: ImageWidget(
                imageUrl: AppImage.searchIcon,
                fit: BoxFit.none,
              ),
              label: 'Search by title',
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'All',
                style: context.headlineLarge?.copyWith(
                  fontSize: 20.sp,
                  color: AppColors.purple,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            Expanded(
              child: ListView.separated(
                itemCount: 20,
                itemBuilder: (_, __) => BuildTileWidget(),
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

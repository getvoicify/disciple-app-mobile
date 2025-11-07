<<<<<<< HEAD
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Bookmarks'),
=======
import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:disciple/features/bookmarks/domain/models/bookmark_with_version.dart';
import 'package:disciple/features/bookmarks/presentation/notifier/bookmark_notifier.dart';
import 'package:disciple/widgets/build_tile_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:disciple/widgets/skeleton/build_tile_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class BookmarksView extends ConsumerStatefulWidget {
  const BookmarksView({super.key});

  @override
  ConsumerState<BookmarksView> createState() => _BookmarksViewState();
}

class _BookmarksViewState extends ConsumerState<BookmarksView> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(AppString.bookmarks),
      leading: ImageWidget(
        imageUrl: AppImage.backIcon,
        fit: BoxFit.none,
        onTap: () => PageNavigator.pop(),
      ),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
      actions: [
        const ImageWidget(imageUrl: AppImage.menuIcon),
        SizedBox(width: 16.w),
      ],
    ),
    body: SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
<<<<<<< HEAD
          const EditTextFieldWidget(
            prefix: ImageWidget(
              imageUrl: AppImage.searchIcon,
              fit: BoxFit.none,
            ),
            label: 'Search by title',
=======
          EditTextFieldWidget(
            prefix: const ImageWidget(
              imageUrl: AppImage.searchIcon,
              fit: BoxFit.none,
            ),
            label: AppString.searchBookmarksByTitle,
            onChanged: (value) =>
                ref.read(bookmarkSearchProvider.notifier).state = value,
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
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

<<<<<<< HEAD
          Expanded(
            child: ListView.separated(
              itemCount: 20,
              itemBuilder: (_, _) => const BuildTileWidget(),
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
            ),
          ),
=======
          Expanded(child: _buildBookmarksList()),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
        ],
      ),
    ),
  );
<<<<<<< HEAD
=======

  StreamBuilder<List<BookmarkWithVersion>> _buildBookmarksList() {
    final search = ref.watch(bookmarkSearchProvider);

    final bookmarksStream = ref
        .watch(bookmarkProvider.notifier)
        .getBookmarks(bookmark: BookmarkEntity(search: search));

    return StreamBuilder<List<BookmarkWithVersion>>(
      stream: bookmarksStream,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const BuildTileSkeleton();
        }

        final bookmarksWithVersions = asyncSnapshot.data ?? [];

        return ListView.separated(
          itemCount: bookmarksWithVersions.length,
          itemBuilder: (_, index) {
            final bookmarkWithVersion = bookmarksWithVersions[index];
            final bookmark = bookmarkWithVersion.bookmark;
            final verse = bookmarkWithVersion.verse;

            return BuildTileWidget(
              model: BuildTileModel(
                title: '${verse.bookName} ${verse.chapter}:${verse.verse}',
                content: verse.verseText,
                date: bookmark.createdAt,
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
        );
      },
    );
  }
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}

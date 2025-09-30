import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/debouncer.dart';
import 'package:disciple/features/bible/domain/param/bible_search_params.dart';
import 'package:disciple/features/bible/presentation/notifier/bible_notifier.dart';
import 'package:disciple/features/bible/presentation/widget/build_chapter_widget.dart';
import 'package:disciple/features/bookmarks/domain/entity/bookmark_entity.dart';
import 'package:disciple/features/bookmarks/presentation/notifier/bookmark_notifier.dart';
import 'package:disciple/widgets/drop_down_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:disciple/widgets/popup_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class BibleView extends ConsumerStatefulWidget {
  const BibleView({super.key});

  @override
  ConsumerState<BibleView> createState() => _BibleViewState();
}

class _BibleViewState extends ConsumerState<BibleView> {
  final List<PopupMenuItemData<String>> menus = const [
    PopupMenuItemData<String>(value: 'devotionals', label: 'Devotionals'),
    PopupMenuItemData<String>(value: 'notes', label: 'Notes'),
    PopupMenuItemData<String>(value: 'bookmarks', label: 'Bookmarks'),
  ];
  final BibleSearchParams _searchParams = BibleSearchParams();
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    unawaited(ref.read(bibleProvider.notifier).searchBibles(_searchParams));
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _debouncer.cancel();

    super.dispose();
  }

  void _onSearchChanged() {
    _debouncer.run(() async {
      if (mounted) {
        _searchParams.searchWord = _searchController.text.trim();
        await ref.read(bibleProvider.notifier).searchBibles(_searchParams);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bibleState = ref.watch(bibleProvider);
    final verses = bibleState.verses;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuWidget<String>(
            items: menus
                .map(
                  (menu) => PopupMenuItemData(
                    icon: menu.icon,
                    value: menu.value,
                    label: menu.label,
                  ),
                )
                .toList(),
            onSelected: (value) => _handleMenuSelection(value),
            icon: AppImage.menuIcon,
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16.w),
        child: Stack(
          children: [
            ListView(
              children: [
                EditTextFieldWidget(
                  controller: _searchController,
                  prefix: const ImageWidget(
                    imageUrl: AppImage.searchIcon,
                    fit: BoxFit.none,
                  ),
                  label: 'Search scripture by words',
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 49.w,
                    vertical: 20.h,
                  ),
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
                ...List.generate(verses.length, (index) {
                  final verse = verses[index];
                  final bool isFirst = index == 0;
                  final bool isLast = index == verses.length - 1;
                  return BuildChapterWidget(
                    isFirst: isFirst,
                    isLast: isLast,
                    verse: verse,
                    startVerse: _searchParams.startVerse,
                    searchTerm: _searchController.text.trim(),
                    onBookmarkTap: () => _handleBookmarkTap(verse),
                  );
                }),
              ],
            ),

            /// TODO: Add audio controller widget
            // const BuildAudioControllerWidget(),
          ],
        ),
      ),
    );
  }

  Future<void> _handleMenuSelection(String option) async {
    if (option == 'devotionals') {
      await PageNavigator.pushRoute(const DevotionalsRoute());
    }

    if (option == 'notes') {
      await PageNavigator.pushRoute(const NotesRoute());
    }

    if (option == 'bookmarks') {
      await PageNavigator.pushRoute(const BookmarksRoute());
    }
  }

  Future<void> _handleBookmarkTap(BibleVerse verse) async {
    final String key = '${verse.bookName}-${verse.chapter}-${verse.verse}';
    await ref
        .read(bookmarkProvider.notifier)
        .addBookmark(
          bookmark: BookmarkEntity(id: key, bibleVerseId: verse.id),
        );
  }
}

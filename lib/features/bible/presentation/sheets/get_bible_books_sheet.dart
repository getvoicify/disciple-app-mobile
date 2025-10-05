import 'dart:async';
import 'package:disciple/app/common/app_fonts.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/bible/data/model/chapter_model.dart';
import 'package:disciple/features/bible/domain/param/bible_search_params.dart';
import 'package:disciple/features/bible/presentation/notifier/bible_notifier.dart';
import 'package:disciple/features/bible/presentation/widget/listview_wheel.dart';
import 'package:disciple/widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO: Fix issue with getting the complete version counts when i visit this page
class GetBibleBooksSheet extends ConsumerStatefulWidget {
  const GetBibleBooksSheet({super.key, required this.searchParams});

  final BibleSearchParams searchParams;

  @override
  ConsumerState<GetBibleBooksSheet> createState() => _GetBibleBooksSheetState();
}

class _GetBibleBooksSheetState extends ConsumerState<GetBibleBooksSheet> {
  late final BibleNotifier _bibleNotifier;
  late BibleSearchParams _searchParams;

  // Scroll controllers
  final FixedExtentScrollController _bookController =
      FixedExtentScrollController();
  final FixedExtentScrollController _chapterController =
      FixedExtentScrollController();
  final FixedExtentScrollController _verseController =
      FixedExtentScrollController();

  int selectedVersion = 0;
  int selectedBook = 0;
  int selectedChapter = 0;
  int selectedVerse = 0;
  int verseCount = 0;

  bool _hasAnimatedOnce = false;

  @override
  void initState() {
    super.initState();
    _searchParams = widget.searchParams;
    _bibleNotifier = ref.read(bibleProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeBibleData();
    });
  }

  Future<void> _initializeBibleData() async {
    await _bibleNotifier.getVersions();
    final bibleState = ref.read(bibleProvider);

    // ✅ Pre-select version
    if (_searchParams.versionId != null) {
      final versionIndex = bibleState.versions.indexWhere(
        (v) => v.id == _searchParams.versionId,
      );
      if (versionIndex >= 0) selectedVersion = versionIndex;
      await _bibleNotifier.getBooks(_searchParams.versionId!);
    }

    // ✅ Pre-select book
    final books = ref.read(bibleProvider).books;
    if (_searchParams.bookName != null && books.isNotEmpty) {
      final bookIndex = books.indexWhere(
        (b) => b.toLowerCase() == _searchParams.bookName!.toLowerCase(),
      );
      if (bookIndex >= 0) {
        selectedBook = bookIndex;

        // Load chapters for the selected book
        await _bibleNotifier.searchBibleChapters(
          BibleSearchParams(
            versionId: _searchParams.versionId,
            bookName: books[bookIndex],
          ),
        );

        // Wait for the chapters to be loaded
        await Future.delayed(const Duration(milliseconds: 100));

        // Get the updated chapters
        final updatedChapters = ref.read(bibleProvider).chapters;
        if (updatedChapters.isNotEmpty) {
          // Find the chapter that matches our search params
          final chapterIndex = updatedChapters.indexWhere(
            (c) => c?.chapter == _searchParams.chapter,
          );

          if (chapterIndex >= 0) {
            selectedChapter = chapterIndex;
            // Update verse count from the chapter info
            final chapter = updatedChapters[chapterIndex];
            if (chapter != null) {
              verseCount = chapter.verseCount;
            }
          }
        }
      }
    }

    // ✅ Pre-select verse (if given)
    if (_searchParams.startVerse > 0 && verseCount > 0) {
      selectedVerse = (_searchParams.startVerse - 1).clamp(0, verseCount - 1);
    } else {
      selectedVerse = 0;
    }

    setState(() {});
    Future.delayed(const Duration(milliseconds: 300), _animateToSelectedItems);
  }

  Future<void> _animateToSelectedItems() async {
    if (_hasAnimatedOnce) return; // ✅ Prevents repeat animation
    _hasAnimatedOnce = true;

    const duration = Duration(milliseconds: 400);
    const curve = Curves.easeOutCubic;

    if (_bookController.hasClients) {
      _bookController.animateToItem(
        selectedBook,
        duration: duration,
        curve: curve,
      );
    }
    if (_chapterController.hasClients) {
      _chapterController.animateToItem(
        selectedChapter,
        duration: duration,
        curve: curve,
      );
    }

    if (_verseController.hasClients && verseCount > 0) {
      _verseController.animateToItem(
        selectedVerse,
        duration: duration,
        curve: curve,
      );
    }
  }

  @override
  void dispose() {
    _bookController.dispose();
    _chapterController.dispose();
    _verseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bibleState = ref.watch(bibleProvider);
    final versions = bibleState.versions;
    final books = bibleState.books;
    final chapters = bibleState.chapters;

    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppString.seletBiblePassage,
            style: context.headlineLarge?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.literata,
            ),
          ),
          SizedBox(height: 20.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Book', 'Chapter', 'Verse']
                .map(
                  (label) => Flexible(
                    child: Text(
                      label,
                      style: context.headlineMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFonts.literata,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 20.h),

          SizedBox(
            height: 180.h,
            child: Row(
              children: [
                BuildListviewWheel(
                  controller: _bookController,
                  itemCount: books.length,
                  selectedIndex: selectedBook,
                  itemBuilder: (i) => books[i],
                  onSelected: (i) => _onBookSelected(books, i, versions),
                ),
                BuildListviewWheel(
                  controller: _chapterController,
                  itemCount: chapters.length,
                  selectedIndex: selectedChapter,
                  itemBuilder: (i) => chapters[i]?.chapter.toString() ?? '',
                  onSelected: (i) => _onChapterSelected(chapters, i),
                ),
                BuildListviewWheel(
                  controller: _verseController,
                  itemCount: verseCount,
                  selectedIndex: selectedVerse,
                  itemBuilder: (i) => '${i + 1}',
                  onSelected: (i) => setState(() => selectedVerse = i),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          ElevatedButtonIconWidget(
            title: AppString.goToPassage,
            onPressed: () async {
              if (versions.isEmpty || books.isEmpty || chapters.isEmpty) return;
              final result = BibleSearchParams(
                versionId: versions[selectedVersion].id,
                bookName: books[selectedBook],
                chapter: chapters[selectedChapter]?.chapter ?? 1,
                startVerse: selectedVerse + 1,
              );
              PageNavigator.pop(result);
            },
          ),
        ],
      ),
    );
  }

  void _onBookSelected(List<String> books, int index, List<Version> versions) {
    setState(() => selectedBook = index);
    final params = BibleSearchParams(
      versionId: versions[selectedVersion].id,
      bookName: books[index],
    );
    unawaited(_bibleNotifier.searchBibleChapters(params));
  }

  void _onChapterSelected(List<ChapterInfo?> chapters, int i) {
    setState(() {
      selectedChapter = i;
      verseCount = chapters[i]?.verseCount ?? 0;
      // selectedVerse = 0;
    });

    // ✅ Only scroll when changing chapters, not on open
    Future.delayed(const Duration(milliseconds: 250), () async {
      if (_verseController.hasClients) {
        await _verseController.animateToItem(
          selectedVerse,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }
}

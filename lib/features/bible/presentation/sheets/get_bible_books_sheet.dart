import 'dart:async';

import 'package:disciple/app/common/app_fonts.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/bible/domain/param/bible_search_params.dart';
import 'package:disciple/features/bible/presentation/notifier/bible_notifier.dart';
import 'package:disciple/features/bible/presentation/widget/listview_wheel.dart';
import 'package:disciple/widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetBibleBooksSheet extends ConsumerStatefulWidget {
  const GetBibleBooksSheet({super.key, required this.searchParams});
  final BibleSearchParams searchParams;

  @override
  ConsumerState<GetBibleBooksSheet> createState() => _GetBibleBooksSheetState();
}

class _GetBibleBooksSheetState extends ConsumerState<GetBibleBooksSheet> {
  late final BibleNotifier _bibleNotifier;
  late BibleSearchParams _searchParams;

  int selectedVersion = 0;
  int selectedBook = 0;
  int selectedChapter = 0;
  int selectedVerse = 0;
  int verseCount = 0;

  @override
  void initState() {
    super.initState();
    _searchParams = widget.searchParams;
    _bibleNotifier = ref.read(bibleProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeBibleData());
  }

  Future<void> _initializeBibleData() async {
    await _bibleNotifier.getVersions();
    final bibleState = ref.read(bibleProvider);

    // Load version
    if (_searchParams.versionId != null) {
      final versionIndex = bibleState.versions.indexWhere(
        (v) => v.id == _searchParams.versionId,
      );
      if (versionIndex >= 0) selectedVersion = versionIndex;
      await _bibleNotifier.getBooks(_searchParams.versionId!);
    }

    // Wait briefly to ensure state propagation
    await Future.delayed(const Duration(milliseconds: 100));

    final books = ref.read(bibleProvider).books;

    // Preselect book/chapter/verse if available
    if (_searchParams.bookName != null && books.isNotEmpty) {
      final bookIndex = books.indexWhere(
        (b) => b.toLowerCase() == _searchParams.bookName!.toLowerCase(),
      );
      if (bookIndex >= 0) {
        selectedBook = bookIndex;

        final params = BibleSearchParams(
          versionId: _searchParams.versionId,
          bookName: books[bookIndex],
        );

        final updatedChapters = await _bibleNotifier.searchBibleChapters(
          params,
        );

        if (updatedChapters.isNotEmpty) {
          final chapterIndex = updatedChapters.indexWhere(
            (c) => c?.chapter == _searchParams.chapter,
          );
          if (chapterIndex >= 0) {
            selectedChapter = chapterIndex;
            verseCount = updatedChapters[chapterIndex]?.verseCount ?? 0;
          }
        }
      }
    }

    // Preselect verse
    selectedVerse = (_searchParams.startVerse > 0 && verseCount > 0)
        ? (_searchParams.startVerse - 1).clamp(0, verseCount - 1)
        : 0;

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bibleState = ref.watch(bibleProvider);
    final versions = bibleState.versions;
    final books = bibleState.books;
    final chapters = bibleState.chapters;

    return SafeArea(
      minimum: EdgeInsets.symmetric(vertical: 16.h),
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
            children: ['Version', 'Book', 'Chapter', 'Verse']
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

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              key: ValueKey('$selectedVersion-$selectedBook'),
              height: 300.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BuildListviewWheel(
                    pageStorageKey: const PageStorageKey('versionWheel'),
                    itemCount: versions.length,
                    selectedIndex: selectedVersion,
                    itemBuilder: (i) => versions[i].abbreviation,
                    onSelected: (i) => _onVersionSelected(i, versions),
                  ),
                  BuildListviewWheel(
                    pageStorageKey: const PageStorageKey('bookWheel'),
                    itemCount: books.length,
                    selectedIndex: selectedBook,
                    itemBuilder: (i) => books[i],
                    onSelected: _onBookSelected,
                  ),
                  BuildListviewWheel(
                    pageStorageKey: const PageStorageKey('chapterWheel'),
                    itemCount: chapters.length,
                    selectedIndex: selectedChapter,
                    itemBuilder: (i) => '${chapters[i]?.chapter ?? 0}',
                    onSelected: _onChapterSelected,
                  ),
                  BuildListviewWheel(
                    pageStorageKey: const PageStorageKey('verseWheel'),
                    itemCount: chapters.isEmpty
                        ? 0
                        : chapters[selectedChapter]?.verseCount ?? 0,
                    selectedIndex: selectedVerse,
                    itemBuilder: (i) => '${i + 1}',
                    onSelected: (i) => setState(() => selectedVerse = i),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ElevatedButtonIconWidget(
              title: AppString.goToPassage,
              onPressed: (versions.isEmpty || books.isEmpty || chapters.isEmpty)
                  ? null
                  : () async {
                      await PageNavigator.pop(
                        BibleSearchParams(
                          versionId: versions[selectedVersion].id,
                          bookName: books[selectedBook],
                          chapter: chapters[selectedChapter]?.chapter ?? 1,
                          startVerse: selectedVerse + 1,
                        ),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onVersionSelected(int index, List<Version> versions) async {
    if (index == selectedVersion) return;

    selectedVersion = index;
    selectedBook = 0;
    selectedChapter = 0;
    selectedVerse = 0;
    verseCount = 0;

    await _bibleNotifier.getBooks(versions[index].id);
  }

  Future<void> _onBookSelected(int index) async {
    final books = ref.read(bibleProvider).books;
    if (index < 0 || index >= books.length) return;

    final selectedBookName = books[index];
    selectedBook = index;
    selectedChapter = 0;
    selectedVerse = 0;
    verseCount = 0;

    await Future.delayed(const Duration(milliseconds: 80));
    await _bibleNotifier.searchBibleChapters(
      BibleSearchParams(
        versionId: _searchParams.versionId,
        bookName: selectedBookName,
      ),
    );

    final chapters = ref.read(bibleProvider).chapters;
    if (mounted) {
      setState(() {
        verseCount = chapters.isNotEmpty ? chapters.first?.verseCount ?? 0 : 0;
      });
    }
  }

  void _onChapterSelected(int index) {
    final chapters = ref.read(bibleProvider).chapters;
    if (index < 0 || index >= chapters.length) return;
    final chapter = chapters[index];
    final chapterNumber = chapter?.chapter ?? 1;

    setState(() {
      selectedChapter = index;
      selectedVerse = 0;
      verseCount = chapter?.verseCount ?? 0;
    });

    _searchParams = _searchParams.copyWith(
      chapter: chapterNumber,
      startVerse: 1,
    );
  }
}

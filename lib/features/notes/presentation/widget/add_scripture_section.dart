import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/features/bible/domain/param/bible_search_params.dart';
import 'package:disciple/features/bible/presentation/sheets/get_bible_books_sheet.dart';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:disciple/widgets/drop_down_widget.dart';
import 'package:disciple/widgets/sheets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddScriptureSection extends ConsumerStatefulWidget {
  const AddScriptureSection({
    super.key,
    required this.onAdd,
    required this.hasError,
  });

  final ValueChanged<ScriptureReference> onAdd;
  final bool hasError;

  @override
  ConsumerState<AddScriptureSection> createState() =>
      _AddScriptureSectionState();
}

class _AddScriptureSectionState extends ConsumerState<AddScriptureSection> {
  BibleSearchParams? _selection;

  Future<void> _openBiblePicker() async {
    final parentBucket = PageStorage.of(context);
    final result = await Sheets.showSheet<BibleSearchParams>(
      child: PageStorage(
        bucket: parentBucket,
        child: GetBibleBooksSheet(
          searchParams: _selection ?? BibleSearchParams(),
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() => _selection = result);
      widget.onAdd(
        ScriptureReference(
          book: result.bookName ?? '',
          chapter: result.chapter,
          verse: result.startVerse,
          endVerse: result.endVerse ?? result.startVerse,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    decoration: BoxDecoration(
      color: AppColors.grey50,
      border: Border.all(
        color: widget.hasError ? Colors.red : AppColors.grey200,
        width: 1.w,
      ),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BuildDropdownWidget(
          title: (_selection?.versionId ?? 'ASV').toUpperCase(),
          onTap: _openBiblePicker,
        ),
        BuildDropdownWidget(
          title: _selection?.bookName ?? 'Book',
          onTap: _openBiblePicker,
        ),
        BuildDropdownWidget(
          title: _selection != null ? '${_selection!.chapter}' : 'Chapter',
          onTap: _openBiblePicker,
        ),
        BuildDropdownWidget(
          title: _selection != null ? '${_selection!.startVerse}' : 'Verse',
          onTap: _openBiblePicker,
        ),
        // BuildDropdownWidget(
        //   title: 'Add',
        //   onTap: _openBiblePicker,
        //   dropdown: false,
        //   color: AppColors.purple,
        //   borderColor: AppColors.purple,
        //   textColor: AppColors.white,
        //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        // ),
      ],
    ),
  );
}

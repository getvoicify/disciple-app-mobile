import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:disciple/widgets/text_highlighter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildChapterWidget extends StatelessWidget {
  const BuildChapterWidget({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.verse,
    required this.searchTerm,
    required this.startVerse,
    required this.onBookmarkTap,
  });

  final bool isFirst;
  final bool isLast;
  final BibleVerse verse;
  final String searchTerm;
  final int startVerse;
  final Function() onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    final TextStyle normalStyle =
        context.headlineMedium?.copyWith(
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.grey700,
        ) ??
        const TextStyle();

    final bool isSearchingWord = searchTerm.isNotEmpty;
    final bool isStartingVerse = verse.verse == startVerse;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(8.r) : const Radius.circular(0),
          bottom: isLast ? Radius.circular(8.r) : const Radius.circular(0),
        ),
        border: Border.all(color: AppColors.grey200, width: .5.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSearchingWord) ...[
            Text(
              '${verse.bookName} ${verse.chapter}:${verse.verse}',
              style: context.headlineMedium?.copyWith(
                fontSize: 16.sp,
                color: AppColors.purple,
              ),
            ),
            SizedBox(height: 8.h),
            RichText(
              text: TextSpan(
                children: searchTerm.isNotEmpty
                    ? TextHighlighter.highlight(
                        text: verse.verseText,
                        searchTerm: searchTerm,
                        normalStyle: normalStyle,
                        highlightStyle: normalStyle.copyWith(
                          color: AppColors.pink,
                        ),
                      )
                    : [TextSpan(text: verse.verseText, style: normalStyle)],
              ),
            ),
          ],

          if (!isSearchingWord) ...[
            RichText(
              text: TextSpan(
                children: [
                  // Verse number with conditional styling
                  TextSpan(
                    text: '${verse.verse} ',
                    style: normalStyle.copyWith(
                      color: isStartingVerse
                          ? AppColors.pink
                          : AppColors.purple4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Verse text with normal style
                  TextSpan(text: verse.verseText, style: normalStyle),
                ],
              ),
            ),
          ],

          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ImageWidget(imageUrl: AppImage.likeIcon2),
              ImageWidget(imageUrl: AppImage.editIcon, onTap: onBookmarkTap),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/widgets/drop_down_widget.dart';

class ScriptureChips extends StatelessWidget {
  final List<ScriptureReference> scriptures;
  final ValueChanged<ScriptureReference> onRemove;

  const ScriptureChips({
    super.key,
    required this.scriptures,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: AppColors.grey50,
      border: Border.all(color: AppColors.grey200, width: 1.w),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: scriptures
            .map(
              (scripture) => Container(
                margin: EdgeInsets.only(right: 16.w),
                child: BuildDropdownWidget(
                  icon: AppImage.cancelIcon2,
                  title:
                      '${scripture.book} ${scripture.chapter}:${scripture.verse} (KJV)',
                  onIconTap: () => onRemove(scripture),
                ),
              ),
            )
            .toList(),
      ),
    ),
  );
}

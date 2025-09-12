import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:disciple/widgets/drop_down_widget.dart';

class AddScriptureSection extends StatelessWidget {
  final ValueChanged<ScriptureReference> onAdd;

  const AddScriptureSection({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    decoration: BoxDecoration(
      color: AppColors.grey50,
      border: Border.all(color: AppColors.grey200, width: 1.w),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildDropdownWidget(title: AppString.kjv),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BuildDropdownWidget(title: 'Book'),
            const BuildDropdownWidget(title: 'Chapter'),
            const BuildDropdownWidget(title: 'Verse'),
            BuildDropdownWidget(
              title: 'Add',
              onTap: () =>
                  onAdd(const ScriptureReference(book: 'Gen', verse: 5)),
              dropdown: false,
              color: AppColors.purple,
              borderColor: AppColors.purple,
              textColor: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            ),
          ],
        ),
      ],
    ),
  );
}

import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:disciple/features/notes/domain/entity/parsed_note_data.dart';
import 'package:disciple/features/notes/presentation/notifier/note_notifier.dart';
import 'package:disciple/features/notes/presentation/state/note_state.dart';
import 'package:disciple/widgets/back_arrow_widget.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:disciple/widgets/popup_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class NoteDetailsView extends ConsumerStatefulWidget {
  const NoteDetailsView({super.key, required this.id});

  final String id;

  @override
  ConsumerState<NoteDetailsView> createState() => _NoteDetailsViewState();
}

class _NoteDetailsViewState extends ConsumerState<NoteDetailsView> {
  final List<Map> menus = [
    {"icon": AppImage.penIcon, "title": "Edit Note", "value": "edit"},
    {"icon": AppImage.downloadIcon, "title": "Download", "value": "download"},
    {"icon": AppImage.deleteIcon, "title": "Delete", "value": "delete"},
  ];
  late String _id;

  @override
  void initState() {
    _id = widget.id;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(noteProvider.notifier).getNoteById(id: _id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final NoteState noteData = ref.watch(noteProvider);
    final ParsedNoteData? note = noteData.note;
    final List<ScriptureReference> scriptureReferences =
        note?.scriptureReferences ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: const BackArrowWidget(),
        actions: [
          PopupMenuWidget<String>(
            items: menus
                .map(
                  (menu) => PopupMenuItemData(
                    icon: menu['icon'] as String?,
                    value: menu['value'] as String,
                    label: menu['title'] as String,
                  ),
                )
                .toList(),
            onSelected: _handleMenuSelection,
            icon: AppImage.dotsIcon,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note?.title ?? '',
                  style: context.headlineLarge?.copyWith(fontSize: 24.sp),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Created: ${note?.createdAt?.timeAgo ?? ''}',
                      style: context.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Last Edited: ${note?.updatedAt?.timeAgo ?? ''}',
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
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.grey50,
                    border: Border.all(color: AppColors.grey300, width: .5.w),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: scriptureReferences
                          .map(
                            (scripture) => Container(
                              margin: EdgeInsets.only(right: 10.w),
                              child: Text(
                                '${scripture.book} ${scripture.chapter}:${scripture.verse}',
                                style: context.bodyLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(height: 21.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 22.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.grey50,
                    border: Border.all(color: AppColors.grey300, width: .5.w),
                  ),
                  child: Text(
                    note?.content ?? '',
                    style: context.bodyMedium?.copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleMenuSelection(String option) async {
    if (option == 'edit') {}
    if (option == 'download') {}
    if (option == 'delete') {
      await ref.read(noteProvider.notifier).deleteNote(id: _id);
    }
  }
}

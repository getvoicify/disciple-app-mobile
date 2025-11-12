import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/notes/domain/entity/parsed_note_data.dart';
import 'package:disciple/features/notes/presentation/notifier/note_notifier.dart';
import 'package:disciple/widgets/back_arrow_widget.dart';
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
  final List<PopupMenuItemData<String>> menus = const [
    PopupMenuItemData<String>(
      value: 'edit',
      label: 'Edit Note',
      icon: AppImage.penIcon,
    ),
    // PopupMenuItemData<String>(
    //   value: 'download',
    //   label: 'Download',
    //   icon: AppImage.downloadIcon,
    // ),
    PopupMenuItemData<String>(
      value: 'delete',
      label: 'Delete',
      icon: AppImage.deleteIcon,
    ),
  ];

  late String _id;

  @override
  void initState() {
    _id = widget.id;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchNoteDetails();
    });
    super.initState();
  }

  Future<void> _fetchNoteDetails() async {
    await ref.read(noteProvider.notifier).getNoteById(id: _id);
  }

  @override
  Widget build(BuildContext context) {
    final noteData = ref.watch(noteProvider);
    final note = noteData.note;
    final scriptureReferences = note?.scriptureReferences ?? [];
    return Scaffold(
      appBar: AppBar(
        leading: const BackArrowWidget(),
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
            onSelected: (value) => _handleMenuSelection(value, note),
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
                    horizontal: 16.w,
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

  Future<void> _handleMenuSelection(String option, ParsedNoteData? note) async {
    if (option == 'edit') {
      await PageNavigator.pushRoute(NewNotesRoute(existingNote: note));
      _fetchNoteDetails();
    }

    if (option == 'delete') {
      await ref.read(noteProvider.notifier).deleteNote(id: _id);
    }
  }
}

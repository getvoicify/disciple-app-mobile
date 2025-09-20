import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/notes/presentation/notifier/note_notifier.dart';
import 'package:disciple/widgets/build_tile_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/floating_side_action_button.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final searchQueryProvider = StateProvider<String>((_) => '');

@RoutePage()
class NotesView extends ConsumerStatefulWidget {
  const NotesView({super.key});

  @override
  ConsumerState<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends ConsumerState<NotesView> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        ref.read(searchQueryProvider.notifier).state = _searchController.text
            .trim();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(AppString.notes),
      actions: const [
        ImageWidget(imageUrl: AppImage.menuIcon),
        SizedBox(width: 16),
      ],
    ),
    body: Consumer(
      builder: (context, ref, _) {
        final searchQuery = ref.watch(searchQueryProvider);

        final notesStream = ref
            .watch(noteProvider.notifier)
            .watchNotes(query: searchQuery);
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  EditTextFieldWidget(
                    controller: _searchController,
                    prefix: const ImageWidget(
                      imageUrl: AppImage.searchIcon,
                      fit: BoxFit.none,
                    ),
                    label: AppString.searchNotesByTitle,
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      AppString.all,
                      style: context.headlineLarge?.copyWith(
                        fontSize: 20.sp,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Expanded(
                    child: StreamBuilder<List<NoteData>>(
                      stream: notesStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final notes = snapshot.data ?? [];
                        if (notes.isEmpty) {
                          return const Center(child: Text('No notes found.'));
                        }

                        return ListView.separated(
                          itemCount: notes.length,
                          itemBuilder: (_, index) {
                            final note = notes[index];
                            final model = BuildTileModel(
                              title: note.title,
                              content: note.isSynced.toString(),
                              date: note.updatedAt,
                            );
                            return BuildTileWidget(
                              model: model,
                              onTap: () => PageNavigator.pushRoute(
                                NoteDetailsRoute(id: note.id),
                              ),
                            );
                          },
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            FloatingSideButtonWidget(
              title: AppString.addNote,
              onTap: () => PageNavigator.pushRoute(NewNotesRoute()),
            ),
          ],
        );
      },
    ),
  );
}

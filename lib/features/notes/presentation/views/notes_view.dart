import 'dart:async';

import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/notes/presentation/notifier/note_notifier.dart';
import 'package:disciple/widgets/build_tile_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/floating_side_action_button.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotesView extends ConsumerStatefulWidget {
  const NotesView({super.key});

  @override
  ConsumerState<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends ConsumerState<NotesView> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

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
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notesStream = ref
        .watch(noteProvider.notifier)
        .watchNotes(query: _searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          const ImageWidget(imageUrl: AppImage.menuIcon),
          SizedBox(width: 16.w),
        ],
      ),
      body: SafeArea(
        child: Stack(
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
                    label: 'Search notes by title',
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
                      'All',
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

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No notes found.'));
                        }

                        final notes = snapshot.data ?? [];

                        return ListView.separated(
                          itemCount: notes.length,
                          itemBuilder: (_, index) {
                            final note = notes[index];

                            final model = BuildTileModel(
                              title: note.title,
                              content: note.content,
                              date: note.updatedAt,
                            );
                            return BuildTileWidget(model: model, onTap: () {});
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.h),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const FloatingSideButtonWidget(title: 'Add Note'),
          ],
        ),
      ),
    );
  }
}

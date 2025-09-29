import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/core/database/app_database.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/debouncer.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/notes/presentation/notifier/note_notifier.dart';
import 'package:disciple/widgets/back_arrow_widget.dart';
import 'package:disciple/widgets/build_tile_widget.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/floating_side_action_button.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

@RoutePage()
class NotesView extends ConsumerStatefulWidget {
  const NotesView({super.key});

  @override
  ConsumerState<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends ConsumerState<NotesView> {
  final _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    unawaited(_onRefresh());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _debouncer.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debouncer.run(() {
      if (mounted) {}
    });
  }

  Future<void> _onRefresh() async {
    try {
      await ref.read(noteProvider.notifier).getNotes();
      _refreshController.refreshCompleted();
    } catch (_) {
      _refreshController.refreshFailed();
    }
  }

  /// FIXME: Implement functionalities for loading more notes
  Future<void> _onLoadMore() async {
    try {
      await ref.read(noteProvider.notifier).getNotes();
      _refreshController.loadComplete();
    } catch (_) {
      _refreshController.loadFailed();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(AppString.notes),
      leading: const BackArrowWidget(),
      actions: const [
        ImageWidget(imageUrl: AppImage.menuIcon),
        SizedBox(width: 16),
      ],
    ),
    body: Consumer(
      builder: (context, ref, _) {
        final notesStream = ref
            .watch(noteProvider.notifier)
            .watchNotes(query: _searchController.text.trim());
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

                        return SmartRefresher(
                          controller: _refreshController,
                          enablePullUp: true,
                          header: const WaterDropHeader(),
                          onRefresh: _onRefresh,
                          onLoading: _onLoadMore,
                          child: ListView.separated(
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
                          ),
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

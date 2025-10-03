import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
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
import 'package:disciple/widgets/skeleton/build_tile_skeleton.dart';
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
  final _refreshController = RefreshController();
  final _debouncer = Debouncer();
  final _cancelToken = CancelToken();
  int _page = 1;
  late NoteNotifier _noteNotifier;

  @override
  void initState() {
    super.initState();
    _noteNotifier = ref.read(noteProvider.notifier);
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _debouncer.cancel();
    _cancelToken.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (!mounted) return;
    _debouncer.run(_onRefresh);
  }

  Future<void> _onRefresh() async {
    try {
      _page = 1;
      await _noteNotifier.getNotes(
        offset: _page,
        cancelToken: _cancelToken,
        query: _searchController.text.trim(),
      );
      _refreshController.refreshCompleted();
    } catch (_) {
      _refreshController.refreshFailed();
    }
  }

  Future<void> _onLoadMore() async {
    try {
      _page++;
      await _noteNotifier.getNotes(
        offset: _page,
        cancelToken: _cancelToken,
        query: _searchController.text.trim(),
      );
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
    body: Stack(
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
              _buildHeader(context),
              SizedBox(height: 32.h),
              _buildNotesList(),
            ],
          ),
        ),
        FloatingSideButtonWidget(
          title: AppString.addNote,
          onTap: () => PageNavigator.pushRoute(NewNotesRoute()),
        ),
      ],
    ),
  );

  Widget _buildHeader(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
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
  );

  Widget _buildNotesList() {
    final notesStream = ref
        .watch(noteProvider.notifier)
        .watchNotes(query: _searchController.text.trim());

    return Expanded(
      child: StreamBuilder<List<NoteData>>(
        stream: notesStream,
        builder: (context, snapshot) {
          final isLoading =
              snapshot.connectionState == ConnectionState.waiting ||
              ref.watch(noteProvider).isLoadingNotes;

          if (isLoading) {
            return ListView.separated(
              itemCount: 25,
              itemBuilder: (_, __) => const BuildTileSkeleton(),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            );
          }

          final notes = snapshot.data ?? [];
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
                return BuildTileWidget(
                  model: BuildTileModel(
                    title: note.title,
                    content: note.content,
                    date: note.updatedAt,
                  ),
                  onTap: () =>
                      PageNavigator.pushRoute(NoteDetailsRoute(id: note.id)),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(height: 12),
            ),
          );
        },
      ),
    );
  }
}

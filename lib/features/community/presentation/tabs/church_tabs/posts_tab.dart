import 'package:dio/dio.dart';
import 'package:disciple/features/community/presentation/notifier/church_notifier.dart';
import 'package:disciple/features/community/presentation/skeleton/post_tile_skeleton.dart';
import 'package:disciple/features/community/presentation/widget/post_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class PostTab extends ConsumerStatefulWidget {
  const PostTab({super.key});

  @override
  ConsumerState<PostTab> createState() => _PostTabState();
}

class _PostTabState extends ConsumerState<PostTab> {
  late ChurchNotifier _churchNotifier;
  final CancelToken _cancelToken = CancelToken();

  @override
  void initState() {
    _churchNotifier = ref.read(churchProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _churchNotifier.getPosts(cancelToken: _cancelToken);
    });
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(churchProvider);
    final posts = state.posts;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: SmartRefresher(
        controller: RefreshController(),
        child: state.isGettingPosts
            ? const PostTileSkeleton()
            : ListView.separated(
                shrinkWrap: true,
                itemCount: posts.length,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemBuilder: (_, _) => const PostTileWidget(),
                separatorBuilder: (context, index) => SizedBox(height: 26.h),
              ),
      ),
    );
  }
}

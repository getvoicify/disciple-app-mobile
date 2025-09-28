import 'package:dio/dio.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/debouncer.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/community/domain/entity/church_entity.dart';
import 'package:disciple/features/community/presentation/notifier/church_notifier.dart';
import 'package:disciple/features/community/presentation/skeleton/church_list_item_skeleton.dart';
import 'package:disciple/features/community/presentation/widget/church_list_item.dart';
import 'package:disciple/features/community/presentation/widget/search_header_delegate.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ChurchTab extends ConsumerStatefulWidget {
  const ChurchTab({super.key});

  @override
  ConsumerState<ChurchTab> createState() => _ChurchState();
}

class _ChurchState extends ConsumerState<ChurchTab> {
  late ChurchNotifier _churchNotifier;
  CancelToken _cancelToken = CancelToken();
  int _page = 1;
  final TextEditingController _searchController = TextEditingController();
  ChurchEntity? _churchEntity;
  final RefreshController _refreshController = RefreshController();
  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    _churchEntity = ChurchEntity(page: _page);
    _churchNotifier = ref.read(churchProvider.notifier);
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refresh();
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _debouncer.cancel();
    _cancelToken.cancel();
    _refreshController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
    _debouncer.run(() async => await _refresh());
  }

  Future<void> _refresh() async {
    _cancelToken = CancelToken();
    _churchEntity
      ?..cancelToken = _cancelToken
      ..page = (_page = 1)
      ..search = _searchController.text.trim();

    try {
      await _churchNotifier.getChurches(parameter: _churchEntity);
      _refreshController.refreshCompleted();
    } catch (_) {
      _refreshController.refreshFailed();
    }
  }

  Future<void> _loadMore() async {
    _page += 1;
    _churchEntity
      ?..cancelToken = _cancelToken
      ..page = _page
      ..search = _searchController.text.trim();

    try {
      await _churchNotifier.getChurches(parameter: _churchEntity);
      _refreshController.loadComplete();
    } catch (_) {
      _refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.h),
    child: SmartRefresher(
      controller: _refreshController,
      onRefresh: _refresh,
      onLoading: _loadMore,
      enablePullUp: true,
      child: CustomScrollView(
        slivers: [
          // Sticky Search Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchHeaderDelegate(
              height: 70.h,
              child: EditTextFieldWidget(
                controller: _searchController,
                titleWidget: const SizedBox.shrink(),
                prefix: const ImageWidget(
                  imageUrl: AppImage.searchIcon,
                  fit: BoxFit.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? ImageWidget(
                        imageUrl: AppImage.cancelIcon,
                        fit: BoxFit.none,
                        onTap: () => _searchController.clear(),
                      )
                    : null,
                label: AppString.searchChurchByName,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ImageWidget(imageUrl: AppImage.locationIcon),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          AppString.locationFilter,
                          style: context.bodyMedium?.copyWith(
                            color: AppColors.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
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
                    _searchController.text.isEmpty
                        ? AppString.allChurches
                        : AppString.searchResults,
                    style: context.headlineLarge?.copyWith(
                      fontSize: 20.sp,
                      color: AppColors.purple,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Consumer(
            builder: (context, ref, child) {
              final church = ref.watch(churchProvider);

              if (church.isLoadingChurches) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const ChurchListItemSkeleton(),
                    childCount: 5,
                  ),
                );
              }

              final churches = church.churches;

              if (churches.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      AppString.noChurchesFound,
                      style: context.bodyMedium,
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final church = churches[index];
                  return ChurchListItem(
                    church: church,
                    onTap: () =>
                        PageNavigator.pushRoute(ChurchRoute(church: church)),
                  );
                }, childCount: churches.length),
              );
            },
          ),
        ],
      ),
    ),
  );
}

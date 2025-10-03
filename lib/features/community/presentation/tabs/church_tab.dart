import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/core/routes/app_router.gr.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/app/utils/debouncer.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/community/data/model/location.dart';
import 'package:disciple/features/community/domain/entity/church_entity.dart';
import 'package:disciple/features/community/presentation/notifier/church_notifier.dart';
import 'package:disciple/features/community/presentation/skeleton/church_list_item_skeleton.dart';
import 'package:disciple/features/community/presentation/widget/church_list_item.dart';
import 'package:disciple/features/community/presentation/widget/location_search_filter.dart';
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

class _ChurchState extends ConsumerState<ChurchTab>
    with AutomaticKeepAliveClientMixin {
  late final ChurchNotifier _churchNotifier;
  final CancelToken _cancelToken = CancelToken();
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  final Debouncer _debouncer = Debouncer();
  final GlobalKey _filterKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  Location? _selectedLocation;
  ChurchEntity? _churchEntity;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _churchNotifier = ref.read(churchProvider.notifier);
    _churchEntity = ChurchEntity(page: _page);

    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tabsRouter = AutoTabsRouter.of(context);
      tabsRouter.addListener(() {
        if (_overlayEntry != null && !mounted) return;

        // If user switches away from this tab, remove overlay
        if (tabsRouter.activeIndex != /* index of this tab */ 2) {
          _overlayEntry?.remove();
          _overlayEntry = null;
        }
      });
      await _refresh();
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _debouncer.cancel();
    _cancelToken.cancel();
    _refreshController.dispose();
    _hideOverlay();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _onSearchChanged() => _debouncer.run(_refresh);

  Future<void> _refresh() async {
    _page = 1;
    _churchEntity = _churchEntity?.copyWith(
      cancelToken: _cancelToken,
      page: _page,
      search: _searchController.text.trim(),
      location: _selectedLocation?.description,
      placeId: _selectedLocation?.placeId,
    );

    try {
      if (_selectedLocation != null) {
        await _churchNotifier.searchChurches(parameter: _churchEntity!);
      } else {
        await _churchNotifier.getChurches(parameter: _churchEntity);
      }
      _refreshController.refreshCompleted();
    } catch (_) {
      _refreshController.refreshFailed();
    }
  }

  Future<void> _loadMore() async {
    _page++;
    _churchEntity = _churchEntity?.copyWith(
      cancelToken: _cancelToken,
      page: _page,
      search: _searchController.text.trim(),
      location: _selectedLocation?.description,
      placeId: _selectedLocation?.placeId,
    );

    try {
      if (_selectedLocation != null) {
        await _churchNotifier.searchChurches(parameter: _churchEntity!);
      } else {
        await _churchNotifier.getChurches(parameter: _churchEntity);
      }
      _refreshController.loadComplete();
    } catch (_) {
      _refreshController.loadFailed();
    }
  }

  void _showOverlay() {
    final renderBox =
        _filterKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: offset.dy,
        left: size.width * 0.2,
        right: size.width * 0.2,
        child: LocationSearchWidget(
          onLocationSelected: (location) async {
            _overlayEntry?.remove();
            _overlayEntry = null;

            _selectedLocation = location;
            setState(() {});
            await _refresh();
          },
        ),
      ),
    );

    Overlay.of(context, debugRequiredFor: widget).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final churches = ref.watch(churchProvider.select((s) => s.churches));
    final isLoading = ref.watch(
      churchProvider.select((s) => s.isLoadingChurches),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _refresh,
        onLoading: _loadMore,
        enablePullUp: true,
        child: GestureDetector(
          onTap: () => _overlayEntry?.remove(),
          child: CustomScrollView(
            slivers: [
              /// 🔍 Sticky Search Bar
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
                            onTap: _searchController.clear,
                          )
                        : null,
                    label: AppString.searchChurchByName,
                  ),
                ),
              ),

              /// 📍 Location Filter + Header
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _selectedLocation != null
                        ? Container(
                            margin: EdgeInsets.only(
                              left: 28.w,
                              right: 28.w,
                              top: 20.h,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const ImageWidget(
                                  imageUrl: AppImage.locationIcon,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    _selectedLocation?.description ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.headlineMedium?.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                ImageWidget(
                                  imageUrl: AppImage.cancelIcon2,
                                  onTap: () =>
                                      setState(() => _selectedLocation = null),
                                ),
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: _showOverlay,
                            child: Container(
                              key: _filterKey,
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
                                children: [
                                  const ImageWidget(
                                    imageUrl: AppImage.locationIcon,
                                  ),
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

              /// 📌 Body (loading, empty, list)
              if (isLoading)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, _) => const ChurchListItemSkeleton(),
                    childCount: 5,
                  ),
                )
              else if (churches.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      AppString.noChurchesFound,
                      style: context.bodyMedium,
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final church = churches[index];
                    return ChurchListItem(
                      church: church,
                      onTap: () =>
                          PageNavigator.pushRoute(ChurchRoute(church: church)),
                    );
                  }, childCount: churches.length),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

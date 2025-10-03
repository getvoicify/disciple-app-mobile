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
import 'package:flutter/cupertino.dart';
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
  late ChurchNotifier _churchNotifier;
  CancelToken _cancelToken = CancelToken();
  int _page = 1;
  final TextEditingController _searchController = TextEditingController();
  ChurchEntity? _churchEntity;
  final RefreshController _refreshController = RefreshController();
  final Debouncer _debouncer = Debouncer();
  final GlobalKey _filterKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  Location? _selectedLocation;

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
    _overlayEntry?.remove();
    _overlayEntry = null;

    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _debouncer.cancel();
    _cancelToken.cancel();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _onSearchChanged() {
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

  void _showOverlay() {
    final renderBox =
        _filterKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // If overlay already exists, just re-position it instead of recreating
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy,
        left: size.width * 0.2,
        right: size.width * 0.2,
        child: LocationSearchWidget(
          onLocationSelected: (location) {
            _overlayEntry?.remove();
            _overlayEntry = null;
            _selectedLocation = location;
            setState(() {});
          },
        ),
      ),
    );

    Overlay.of(context, debugRequiredFor: widget).insert(_overlayEntry!);
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
          onTap: () {
            _overlayEntry?.remove();
            _overlayEntry = null;
          },
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
                    GestureDetector(
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
                    ),
                    const SizedBox(height: 24),
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

              if (isLoading)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const ChurchListItemSkeleton(),
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

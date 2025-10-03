import 'dart:async';

import 'package:dio/dio.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/utils/debouncer.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/community/data/model/location.dart';
import 'package:disciple/features/community/domain/entity/church_entity.dart';
import 'package:disciple/features/community/presentation/notifier/church_notifier.dart';
import 'package:disciple/widgets/edit_text_field_with.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationSearchWidget extends ConsumerStatefulWidget {
  const LocationSearchWidget({super.key, required this.onLocationSelected});

  final Function(Location) onLocationSelected;

  @override
  ConsumerState<LocationSearchWidget> createState() =>
      _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends ConsumerState<LocationSearchWidget> {
  late ChurchNotifier _churchNotifier;
  final CancelToken _cancelToken = CancelToken();
  final TextEditingController _controller = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _churchNotifier = ref.read(churchProvider.notifier);
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (mounted && _controller.text.isNotEmpty) {
      _debouncer.run(() {
        unawaited(
          _churchNotifier.getLocations(
            parameter: ChurchEntity(location: _controller.text),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(churchProvider).locations;

    return Card(
      elevation: 3.h,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EditTextFieldWidget(
              titleWidget: const SizedBox.shrink(),
              contentPadding: EdgeInsets.all(8.w),
              controller: _controller,
              label: 'Enter location',
              prefix: const ImageWidget(
                imageUrl: AppImage.locationDot,
                fit: BoxFit.none,
              ),
            ),
            if (locations.isNotEmpty) ...[
              SizedBox(height: 12.h),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (_, index) {
                    final location = locations[index];
                    return GestureDetector(
                      onTap: () => widget.onLocationSelected.call(location),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.grey200),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 7.w,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ImageWidget(
                              imageUrl: AppImage.locationIconThin,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                location.description ?? '',
                                style: context.bodyMedium?.copyWith(
                                  fontSize: 12.sp,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, _) => SizedBox(height: 12.h),
                  itemCount: locations.length,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

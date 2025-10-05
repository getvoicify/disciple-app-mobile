import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/config/app_helper.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/features/community/data/model/church.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:disciple/widgets/popup_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key, required this.church});

  final Church church;

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  Church? _church;
  final List<PopupMenuItemData> _churchInfo = [];
  SocialLink? _socialLink;
  @override
  void initState() {
    _church = widget.church;
    _socialLink = widget.church.socialLinks;

    _churchInfo.addAll([
      PopupMenuItemData(
        label: '',
        value: _socialLink?.facebook,
        icon: AppImage.facebookIcon,
      ),
      PopupMenuItemData(
        label: '',
        value: _socialLink?.youtube,
        icon: AppImage.youtubeIcon,
      ),
      PopupMenuItemData(
        label: '',
        value: _socialLink?.instagram,
        icon: AppImage.instagramIcon,
      ),

      /// TODO: Add thread icon
      const PopupMenuItemData(label: '', value: '', icon: AppImage.threadIcon),
      PopupMenuItemData(
        label: '',
        value: _socialLink?.twitterX,
        icon: AppImage.xIcon,
      ),
      PopupMenuItemData(
        label: '',
        value: _socialLink?.tiktok,
        icon: AppImage.tiktokIcon,
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: ListView(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling in this ListView
      children: [
        SizedBox(height: 20.h),
        Text(
          _church?.missionStatement ?? '',
          style: context.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        const Divider(),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const ImageWidget(
              imageUrl: AppImage.locationIcon,
              fit: BoxFit.none,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                '${_church?.address?.street}, ${_church?.getAddress}',
                style: context.bodyMedium?.copyWith(fontSize: 12.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          height: 156.h,
          margin: EdgeInsets.symmetric(horizontal: 28.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
          child: GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(_church?.latitude ?? 0, _church?.longitude ?? 0),
            ),
          ),
        ),
        SizedBox(height: 33.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          decoration: const BoxDecoration(color: AppColors.purple3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.contactUs,
                style: context.headlineLarge?.copyWith(fontSize: 24.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                AppString.ourFriendlyTeamWouldLoveToHearFromYou,
                style: context.bodyMedium?.copyWith(fontSize: 14.sp),
              ),
              SizedBox(height: 20.h),
              Align(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: AppColors.purple,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ImageWidget(imageUrl: AppImage.emailIcon),
                      SizedBox(width: 8.w),
                      Text(
                        AppString.sendEmail,
                        style: context.bodyMedium?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          AppString.connectWithUsOnOurSocials,
          style: context.headlineLarge?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        SizedBox(height: 12.h),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20.w,
          children: _churchInfo
              .map(
                (icon) => ImageWidget(
                  imageUrl: icon.icon ?? '',
                  fit: BoxFit.none,
                  onTap: () async => await AppHelper.openUrl(icon.value ?? ''),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 20.h), // Add bottom padding
      ],
    ),
  );
}

import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/common/app_strings.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoreView extends StatefulWidget {
  const MoreView({super.key});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  // Data models for menu items
  final List<MenuItemModel> quickLinks = [
    MenuItemModel(
      icon: AppImage.handsPrayingIcon,
      title: AppString.prayerWall,
      hasArrow: true,
      onTap: () {},
    ),
    MenuItemModel(
      icon: AppImage.noteIcon,
      title: AppString.notes,
      hasArrow: true,
      onTap: () {},
    ),
    MenuItemModel(
      icon: AppImage.bookmark,
      title: AppString.bookmarks,
      hasArrow: true,
      onTap: () {},
    ),
  ];

  final List<MenuItemModel> accountSettings = [
    MenuItemModel(
      icon: AppImage.settingsIcon,
      title: AppString.settings,
      hasArrow: true,
      onTap: () {},
    ),
    MenuItemModel(
      icon: AppImage.helpIcon,
      title: AppString.help,
      hasArrow: true,
      onTap: () {},
    ),
    MenuItemModel(
      icon: AppImage.notificationIcon2,
      title: AppString.notifications,
      hasArrow: true,
      onTap: () {},
    ),
    MenuItemModel(
      icon: AppImage.darkThemeIcon,
      title: AppString.darkMode,
      hasArrow: false,
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        // Profile Card
        CardContainer(
          child: Row(
            children: [
              const CircleAvatar(key: Key('profile_avatar')),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  AppString.annabelle,
                  style: context.headlineMedium?.copyWith(fontSize: 16.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Friends Card
        CardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppString.friends,
                style: context.headlineMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppString.friendCount,
                      style: context.headlineMedium?.copyWith(fontSize: 20.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      AppString.inviteFriends,
                      style: context.headlineMedium?.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Quick Links Card
        CardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppString.quickLinks,
                style: context.headlineLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20.h),
              // Using ListView.separated for better performance
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: quickLinks.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) => MenuItemTile(
                  item: quickLinks[index],
                  key: ValueKey('quick_link_$index'),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Manage Account Card
        CardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppString.manageAccount,
                style: context.headlineLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20.h),
              // Using ListView.separated for better performance
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: accountSettings.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) => MenuItemTile(
                  item: accountSettings[index],
                  key: ValueKey('account_setting_$index'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Reusable card container widget
class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: AppColors.grey200, width: .5.w),
    ),
    child: child,
  );
}

// Menu item model
class MenuItemModel {
  final String icon;
  final String title;
  final bool hasArrow;
  final VoidCallback onTap;
  final Widget? trailing;

  MenuItemModel({
    required this.icon,
    required this.title,
    required this.hasArrow,
    required this.onTap,
    this.trailing,
  });
}

// Reusable menu item tile
class MenuItemTile extends StatelessWidget {
  final MenuItemModel item;

  const MenuItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: item.onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          ImageWidget(imageUrl: item.icon),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              item.title,
              style: context.headlineMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          if (item.trailing != null) item.trailing!,
          if (item.hasArrow) ...[
            SizedBox(width: 16.w),
            const ImageWidget(imageUrl: AppImage.arrowRightIcon),
          ],
        ],
      ),
    ),
  );
}

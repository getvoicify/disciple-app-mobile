import 'package:disciple/app/common/app_images.dart';

class BottomNavigation {
  final String label;
  final String icon;

  BottomNavigation({required this.label, required this.icon});
}

final bottomNavigations = [
  BottomNavigation(label: 'Home', icon: AppImage.homeIcon),
  BottomNavigation(label: 'Bible', icon: AppImage.bibleIcon),
  BottomNavigation(label: 'Community', icon: AppImage.communityIcon),
  BottomNavigation(label: 'Reminder', icon: AppImage.reminderIcon),
  BottomNavigation(label: 'More', icon: AppImage.moreIcon),
];

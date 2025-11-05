import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/features/dashboard/data/bottom_navigations.dart';
import 'package:disciple/features/notes/data/resync/module/module.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<DashboardView> {
  late final List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    ref.read(syncManagerProvider);

    _navItems = bottomNavigations
        .map(
          (nav) => BottomNavigationBarItem(
            icon: ImageWidget(imageUrl: nav.icon),
            label: nav.label,
          ),
        )
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => AutoTabsRouter.pageView(
    builder: (context, child, _) {
      final router = AutoTabsRouter.of(context);
      return Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: router.activeIndex,
          onTap: router.setActiveIndex,
          items: _navItems.mapIndexed((index, _) {
            final isActive = index == router.activeIndex;
            return BottomNavigationBarItem(
              icon: ImageWidget(
                imageUrl: bottomNavigations[index].icon,
                iconColor: isActive ? AppColors.purple : null,
              ),
              label: bottomNavigations[index].label,
            );
          }).toList(),
        ),
      );
    },
  );
}

import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A data class to hold the value and label for a single popup menu item.
class PopupMenuItemData<T> {
  const PopupMenuItemData({
    required this.value,
    required this.label,
    this.icon,
<<<<<<< HEAD
=======
    this.child,
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
  });
  final T value;
  final String label;
  final String? icon;
<<<<<<< HEAD
=======
  final Widget? child;
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}

/// A reusable popup menu button widget.
class PopupMenuWidget<T> extends StatelessWidget {
  const PopupMenuWidget({
    super.key,
    required this.items,
    required this.onSelected,
    this.icon,
<<<<<<< HEAD
=======
    this.child,
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
  });

  /// The list of items to display in the menu.
  final List<PopupMenuItemData<T>> items;

  /// The callback that is called when a menu item is selected.
  final void Function(T) onSelected;

  /// The icon to display for the button.
  final String? icon;

<<<<<<< HEAD
=======
  final Widget? child;

>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
  @override
  Widget build(BuildContext context) => PopupMenuButton<T>(
    onSelected: onSelected,
    itemBuilder: (context) => items
        .map(
          (item) => PopupMenuItem<T>(
            value: item.value,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.icon != null) ...[
                  ImageWidget(imageUrl: item.icon!, fit: BoxFit.none),
                  SizedBox(width: 8.w),
                ],
                Text(item.label),
              ],
            ),
          ),
        )
        .toList(),
<<<<<<< HEAD
    icon: icon != null ? ImageWidget(imageUrl: icon!) : null,
=======
    icon: child ?? (icon != null ? ImageWidget(imageUrl: icon!) : null),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
  );
}

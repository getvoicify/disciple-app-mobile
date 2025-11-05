import 'package:disciple/app/common/app_images.dart';
import 'package:disciple/app/core/routes/page_navigator.dart';
import 'package:disciple/widgets/image_widget.dart';
import 'package:flutter/material.dart';

class BackArrowWidget extends StatelessWidget {
  const BackArrowWidget({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap ?? () => PageNavigator.pop(),
    child: const ImageWidget(imageUrl: AppImage.backIcon, fit: BoxFit.none),
  );
}

import 'package:disciple/app/common/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final bool isAsset = imageUrl.startsWith(AppImage.imagePath);

    if (isAsset && imageUrl.endsWith(".svg")) {
      return SvgPicture.asset(imageUrl, width: width, height: height, fit: fit);
    }

    if (isAsset && imageUrl.endsWith('.png')) {
      return Image.asset(imageUrl, width: width, height: height, fit: fit);
    }

    return const Placeholder();
  }
}

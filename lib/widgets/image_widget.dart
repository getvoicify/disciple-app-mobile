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
    this.onTap,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isAsset = imageUrl.startsWith(AppImage.imagePath);

    if (isAsset && imageUrl.endsWith(".svg")) {
      return InkWell(
        onTap: onTap,
        child: SvgPicture.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    }

    if (isAsset && imageUrl.endsWith('.png')) {
      return InkWell(
        onTap: onTap,
        child: Image.asset(imageUrl, width: width, height: height, fit: fit),
      );
    }

    return const Placeholder();
  }
}

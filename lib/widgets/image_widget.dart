import 'package:disciple/app/common/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.onTap,
    this.iconColor,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Function()? onTap;
  final Color? iconColor;

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
          colorFilter: iconColor == null
              ? null
              : ColorFilter.mode(iconColor!, BlendMode.srcIn),
        ),
      );
    }

    if (isAsset && imageUrl.endsWith('.png')) {
      return InkWell(
        onTap: onTap,
        child: Image.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          color: iconColor,
        ),
      );
    }

    if (!isAsset && imageUrl.startsWith('https://')) {
      return InkWell(
        onTap: onTap,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    }

    return const Placeholder();
  }
}

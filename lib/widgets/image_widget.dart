import 'package:disciple/app/common/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
<<<<<<< HEAD
=======
import 'package:cached_network_image/cached_network_image.dart';
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.onTap,
<<<<<<< HEAD
=======
    this.iconColor,
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Function()? onTap;
<<<<<<< HEAD
=======
  final Color? iconColor;
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b

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
<<<<<<< HEAD
=======
          colorFilter: iconColor == null
              ? null
              : ColorFilter.mode(iconColor!, BlendMode.srcIn),
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
        ),
      );
    }

    if (isAsset && imageUrl.endsWith('.png')) {
      return InkWell(
        onTap: onTap,
<<<<<<< HEAD
        child: Image.asset(imageUrl, width: width, height: height, fit: fit),
=======
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
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
      );
    }

    return const Placeholder();
  }
}

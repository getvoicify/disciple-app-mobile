import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:disciple/app/config/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppHelper {
  static final logger = getLogger("AppHelper");

  static Future<void> openUrl(
    String url, {
    LaunchMode mode = LaunchMode.inAppWebView,
  }) async {
    if (url.isNotEmpty) {
      try {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: mode);
        } else {
          logger.e('Url cannot be launched');
        }
      } catch (e) {
        logger.e(e);
      }
    }
  }

  static Future<Uint8List?> captureWidget(GlobalKey key) async {
    try {
      final RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Error capturing widget: $e");
      return null;
    }
  }

  static Future<void> shareFile(File file) async {
    try {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: "Today's Scripture 📖"),
      );
    } catch (e) {
      logger.e(e);
    }
  }
}

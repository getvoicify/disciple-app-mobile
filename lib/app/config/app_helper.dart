import 'package:disciple/app/config/app_logger.dart';
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
}

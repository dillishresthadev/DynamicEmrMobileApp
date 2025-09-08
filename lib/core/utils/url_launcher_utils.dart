import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtils {
  /// Launch a generic URL (opens in external app if available)
  static Future<void> launchUrlExternal(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Open app rating page (Play Store for Android, App Store for iOS)
  static Future<void> openAppRating() async {
    final url = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=com.paailatechnologies.dynamicemr"
        : "https://apps.apple.com/us/app/dynamicemr-hr/id6752019325";

    await launchUrlExternal(url);
  }

  /// Open Facebook page or group
  static Future<void> openFacebook() async {
    String url;
    url = "https://www.facebook.com/DynamicEMR/";
    await launchUrlExternal(url);
  }

  /// Open YouTube channel
  static Future<void> openYouTube(String channelId) async {
    final url = "https://www.youtube.com/channel/$channelId";
    await launchUrlExternal(url);
  }

  /// Open Instagram profile
  static Future<void> openInstagram() async {
    final url = "https://www.instagram.com/dynamicemr/";
    await launchUrlExternal(url);
  }

  /// Open TikTok profile
  static Future<void> openTikTok(String username) async {
    final url = "https://www.tiktok.com/@$username";
    await launchUrlExternal(url);
  }
}

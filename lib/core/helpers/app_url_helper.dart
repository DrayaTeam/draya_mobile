import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:url_launcher/url_launcher.dart";

class AppUrlHelper {
  static void launchURL(String url, BuildContext context) async {
     await HapticFeedback.lightImpact();
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Could not launch $url",
            ),
          ),
        );
      }
    }
  }
}

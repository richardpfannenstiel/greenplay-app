import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class DirectionsService {
  // DirectionsService._();
  static final shared = DirectionsService();

  void launchMaps(double latitude, double longitude) async {
    if (Platform.isAndroid) {
      // Android-specific code
      launchGoogleMaps(latitude, longitude);
    } else if (Platform.isIOS) {
      // iOS-specific code
      launchAppleMaps(latitude, longitude);
    }
  }

  void launchGoogleMaps(double latitude, double longitude) async {
    String googleUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude";
    // 'https://www.google.com/maps/dir/?api=1&query=$latitude,$longitude';
    if (!await launchUrl(Uri.parse(googleUrl),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not open the map';
    }
  }

  void launchAppleMaps(double latitude, double longitude) async {
    String appleUrl = "http://maps.apple.com/?&daddr=$latitude,$longitude";
    // "http://maps.apple.com/?q=Greenplay+Station&sll=$latitude,$longitude";
    if (!await launchUrl(Uri.parse(appleUrl),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not open the map';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtils {
  /// Checks and requests location permission
  static Future<bool> _handlePermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDialog(
        context,
        "Location Services Disabled",
        "Please enable location services to continue.",
        openSettings: true,
      );
      return false;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationDialog(
          context,
          "Permission Denied",
          "Location permission is required to use this feature.",
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationDialog(
        context,
        "Permission Denied Forever",
        "You have permanently denied location permission. Please enable it in settings.",
        openSettings: true,
      );
      return false;
    }

    return true;
  }

  /// Gets the current location (latitude & longitude)
  static Future<Position?> getCurrentLocation(BuildContext context) async {
    final hasPermission = await _handlePermission(context);
    if (!hasPermission) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );
    } catch (e) {
      debugPrint("Error getting location: $e");
      return null;
    }
  }

  /// Shortcut method to just get latitude & longitude as a map
  static Future<Map<String, double>?> getLatLng(BuildContext context) async {
    final position = await getCurrentLocation(context);
    if (position == null) return null;

    return {"latitude": position.latitude, "longitude": position.longitude};
  }

  /// Show custom dialog for permission issues
  static void _showLocationDialog(
    BuildContext context,
    String title,
    String message, {
    bool openSettings = false,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (openSettings)
            TextButton(
              onPressed: () {
                Geolocator.openAppSettings();
                Navigator.of(ctx).pop();
              },
              child: const Text("Open Settings"),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

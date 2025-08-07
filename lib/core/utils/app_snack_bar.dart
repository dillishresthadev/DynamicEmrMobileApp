import 'package:flutter/material.dart';

enum SnackbarType { success, error, info }

class AppSnackBar {
  static void show(BuildContext context, String message, SnackbarType type) {
    Color backgroundColor;
    Icon icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = Colors.green;
        icon = Icon(Icons.check_circle, color: Colors.white);
        break;
      case SnackbarType.error:
        backgroundColor = Colors.red;
        icon = Icon(Icons.error, color: Colors.white);
        break;
      case SnackbarType.info:
        backgroundColor = Colors.blue;
        icon = Icon(Icons.info, color: Colors.white);
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            icon,
            SizedBox(width: 8),
            Expanded(
              child: Text(message, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 1),
      ),
    );
  }
}

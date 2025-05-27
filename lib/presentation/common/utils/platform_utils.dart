import 'dart:io';

class PlatformUtils {
  static double getPadding({required double ios, required double android}) {
    return Platform.isIOS ? ios : android;
  }

  static double getHeight({required double ios, required double android}) {
    return Platform.isIOS ? ios : android;
  }

  static double getWidth({required double ios, required double android}) {
    return Platform.isIOS ? ios : android;
  }
}
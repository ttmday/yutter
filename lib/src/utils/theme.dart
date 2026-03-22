import 'package:flutter/services.dart';

class ThemeUtils {
  static void setStatusBarAndNavigationBarTheme({
    required Color color,
    required Brightness brightness,
    Brightness? brightnessNavigationBar,
    Color? navigationBarColor,
    bool changeNavigationBrightness = true,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: brightness,
        systemNavigationBarIconBrightness: changeNavigationBrightness
            ? (brightnessNavigationBar ?? brightness)
            : null,
        statusBarColor: color, //any color of your choice
        systemNavigationBarColor: navigationBarColor ?? color,
      ),
    );
  }
}

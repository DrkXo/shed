import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

class WindowManagerService {
  // Singleton instance of ShedUiService
  static final WindowManagerService _instance =
      WindowManagerService._internal();

  // Private constructor for the singleton instance
  WindowManagerService._internal();

  // Factory constructor to return the same instance
  factory WindowManagerService() {
    return _instance;
  }

  /// Initializes the window and UI service for desktop platforms.
  Future<void> initialize() async {
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.setMinimumSize(const Size(500, 600));
      await windowManager.show();
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
    });
  }
}

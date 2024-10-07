import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shed/src/services/window_manager_service.dart';
import 'package:shed/src/shed.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManager.instance.ensureInitialized();

  final WindowManagerService windowManagerService = WindowManagerService();

  await windowManagerService.initialize();

  runApp(
    const ProviderScope(
      child: Shed(),
    ),
  );
}

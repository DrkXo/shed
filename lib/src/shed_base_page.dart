import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shed/src/providers/providers_index.dart';
import 'package:shed/src/services/app_lyfe_cycle_observer.dart';
import 'package:shed/src/utils/logger.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class ShedBasePage extends ConsumerStatefulWidget {
  const ShedBasePage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShedBasePageState();
}

class _ShedBasePageState extends ConsumerState<ShedBasePage>
    with WindowListener, TrayListener {
  late final AppLifecycleObserver _lifecycleObserver;

  @override
  void initState() {
    super.initState();
    // Initialize your AppLifecycleObserver
    _lifecycleObserver = AppLifecycleObserver(ref);
    // Add the observer
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
    windowManager.addListener(this);
    trayManager.addListener(this);
  }

  @override
  void dispose() {
    // Remove the observer when the widget is disposed
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    windowManager.removeListener(this);
    // trayManager.destroy();
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose && mounted) {
      await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure you want to close this window?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              child: const Text('Exit'),
              onPressed: () {
                ref.invalidate(inItNotifierProvider);
                exit(0);
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    logger.i(menuItem.key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: DragToMoveArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (!kIsWeb) const WindowButtons(),
            ],
          ),
        ),
      ),
      body: widget.child,
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      width: 138,
      child: WindowCaption(
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

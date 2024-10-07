import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shed/src/providers/providers_index.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final WidgetRef ref;

  AppLifecycleObserver(this.ref);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // ignore: unused_local_variable
    final aria2cRpcService = ref.read(aria2cRpcServerProvider.future);

    switch (state) {
      case AppLifecycleState.resumed:
        // App is in the foreground, resume or start process
        /*  aria2cRpcService.then((service) async {
          if (!await service.isRunning()) {
            await service.tryStart(killIfFound: true);
          }
        }); */
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App is in the background, pause or stop process
        /* aria2cRpcService.then((service) async {
          await service.stop(); // Stop the process to save resources
        }); */
        break;
      case AppLifecycleState.detached:
        // App is exiting, stop the process
        /* aria2cRpcService.then((service) async {
          await service.stop();
        }); */
        break;
      default:
        break;
    }
  }

  void dispose() {
    // Clean up any listeners when the observer is no longer needed
    WidgetsBinding.instance.removeObserver(this);
  }
}

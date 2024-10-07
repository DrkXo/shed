import 'package:tray_manager/tray_manager.dart';

class TrayManagerService {
  Menu menu = Menu(
    items: [
      MenuItem(
        key: 'add_download',
        label: 'Add Url',
      ),
      MenuItem.separator(),
      MenuItem(
        key: 'exit_app',
        label: 'Exit',
      ),
    ],
  );

  Future<TrayManager> start() async {
    await trayManager.setIcon(
      'assets/logo/shed.png',
    );

    await trayManager.setContextMenu(menu);

    return trayManager;
  }

  Future<void> destroy() async {
    await trayManager.destroy();
  }
}

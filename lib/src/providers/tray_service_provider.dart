part of "providers_index.dart";

@riverpod
Future<TrayManagerService> trayService(TrayServiceRef ref) async {
  final TrayManagerService trayManagerService = TrayManagerService();

  await trayManagerService.start();

  ref.onDispose(trayManagerService.destroy);

  return trayManagerService;
}

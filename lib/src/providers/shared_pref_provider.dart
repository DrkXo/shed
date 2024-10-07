part of "providers_index.dart";

@riverpod
Future<SharedPreferencesService> sharedPrefService(
  SharedPrefServiceRef ref,
) async {
  final service = SharedPreferencesService();
  await service.initialize();

  ref.onDispose(service.dispose);
  return service;
}

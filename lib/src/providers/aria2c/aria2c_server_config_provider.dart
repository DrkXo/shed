part of '../providers_index.dart';

@riverpod
Future<Aria2cServerConfig> aria2cServerConfiguration(
  Aria2cServerConfigurationRef ref,
) async {
  final dir = await getDownloadsDirectory();
  final pref = await ref.watch(sharedPrefServiceProvider.future);
  Aria2cServerConfig aria2cServerConfig = Aria2cServerConfig(
    dir: dir!.path,
  );

  ref.onDispose(pref.dispose);

  return aria2cServerConfig;
}

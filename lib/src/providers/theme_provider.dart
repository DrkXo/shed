part of "providers_index.dart";

@riverpod
FutureOr<ShedThemeConfig> shedTheme(ShedThemeRef ref) {
  final pref = ref.watch(sharedPrefServiceProvider);
  return ShedThemeConfig();
}

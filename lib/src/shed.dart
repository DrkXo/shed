import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shed/constants/constants.dart';
import 'package:shed/src/providers/providers_index.dart';
import 'package:shed/src/router/router_provider.dart';

class Shed extends ConsumerWidget {
  const Shed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final theme = ref.watch(shedThemeProvider.select((x) => x.value!));

    return MaterialApp.router(
      title: Env.appName,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.themeMode,
    );
  }
}

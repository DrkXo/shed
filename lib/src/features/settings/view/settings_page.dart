import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shed/src/router/routes.dart';
import 'package:shed/src/utils/extensions/string/string_extentions.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Routes.settings.name.toTitleCase()),
      ),
      body: Text('Settings'),
    );
  }
}

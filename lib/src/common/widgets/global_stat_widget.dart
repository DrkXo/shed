import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shed/src/providers/providers_index.dart';
import 'package:shed/src/utils/extensions/aria2c/aria2c_global_stat_extensions.dart';

class GlobalStatWidget extends ConsumerWidget {
  const GlobalStatWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalStat =
        ref.watch(aria2cGlobalStatProvider.select((x) => x.value));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (globalStat != null && globalStat.parsedItemsForDisplay.isNotEmpty)
            Text(
              globalStat.parsedItemsForDisplay.join(' '),
            ),
        ],
      ),
    );
  }
}

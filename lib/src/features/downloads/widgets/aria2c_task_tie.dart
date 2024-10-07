import 'package:aria2cf/aria2cf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shed/constants/constants.dart';
import 'package:shed/src/providers/providers_index.dart';
import 'package:shed/src/utils/extensions/aria2c/aria2c_task_extension.dart';

class Aria2cTaskTile extends ConsumerWidget {
  const Aria2cTaskTile({
    super.key,
    required this.task,
  });

  final Aria2cTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row: File Name and Operation Icon Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.fileName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow, color: Colors.grey),
                  onPressed: () {
                    if (task.gid != null) {
                      ref.read(aria2cSocketProvider).sendData(
                            request: Aria2cRequest.unpause(
                              secret: Env.aria2cSecret,
                              gid: task.gid!,
                            ),
                          );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.pause, color: Colors.grey),
                  onPressed: () {
                    if (task.gid != null) {
                      ref.read(aria2cSocketProvider).sendData(
                            request: Aria2cRequest.pause(
                              secret: Env.aria2cSecret,
                              gid: task.gid!,
                            ),
                          );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red),
                  onPressed: () {
                    if (task.gid != null) {
                      ref.read(aria2cSocketProvider).sendData(
                            request: Aria2cRequest.forcePause(
                              secret: Env.aria2cSecret,
                              gid: task.gid!,
                            ),
                          );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Second Row: Progress Bar and Stats
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Bar
                LinearProgressIndicator(
                  value: task.progress,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Downloaded: ${task.fileCompletedSizeReadable}/${task.fileTotalSizeReadable}'),
                    Row(
                      children: [
                        Text('Speed: ${task.downloadSpeedReadable}'),
                        Text('Connections: ${task.connections}'),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

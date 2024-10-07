import 'package:aria2cf/aria2cf.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shed/src/utils/extensions/file/file_extentions.dart';
import 'package:shed/src/utils/extensions/network/network_extension.dart';

extension Aria2cTaskExtension on Aria2cTask {
  double get progress => totalLength != null && totalLength! > 0
      ? ((completedLength ?? 0) / totalLength!) /* * 100 */
      : 0.0;

  String get fileName => files != null
      ? files![0].path == null
          ? 'Unknown'
          : basename(files![0].path!)
      : 'Unknown';

  String get downloadSpeedReadable => NetworkUtility.formatSpeed(
        downloadSpeed ?? 0,
      );

  String get fileCompletedSizeReadable =>
      FileSizeFormatter.format(completedLength ?? 0);
  String get fileTotalSizeReadable =>
      FileSizeFormatter.format(totalLength ?? 0);

  IconData get iconForStatus {
    switch (status) {
      case Aria2cTaskStatus.waiting:
        return Icons.hourglass_empty;
      case Aria2cTaskStatus.active:
        return Icons.play_arrow;
      case Aria2cTaskStatus.paused:
        return Icons.pause;
      case Aria2cTaskStatus.error:
        return Icons.pause;
      case Aria2cTaskStatus.complete:
        return Icons.done;
      case Aria2cTaskStatus.removed:
        return Icons.delete;
      default:
        return Icons.question_mark;
    }
  }
}

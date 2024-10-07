import 'package:aria2cf/aria2cf.dart';
import 'package:shed/src/utils/extensions/network/network_extension.dart';

extension Aria2cTaskExtension on Aria2cGlobalStat {
  List<String> get parsedItemsForDisplay {
    return [
      if (downloadSpeed != null && downloadSpeed != 0)
        '\u{2191} ${NetworkUtility.formatSpeed(downloadSpeed!)}',
      if (uploadSpeed != null && uploadSpeed != 0)
        '\u{2193} ${NetworkUtility.formatSpeed(uploadSpeed!)}',
      if (numActive != null && numActive != 0) 'Active : $numActive',
      if (numWaiting != null && numWaiting != 0) 'Waiting : $numWaiting',
      if (numStopped != null && numStopped != 0) 'Stopped : $numStopped',
    ];
  }
}

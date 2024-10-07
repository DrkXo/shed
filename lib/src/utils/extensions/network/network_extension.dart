// ignore_for_file: constant_identifier_names

abstract class NetworkUtility {
  // Converts speed from bytes to a more readable format (KB, MB)
  static String formatSpeed(int speedInBytes) {
    const int KB = 1024;
    const int MB = 1024 * 1024;

    if (speedInBytes >= MB) {
      return '${(speedInBytes / MB).toStringAsFixed(2)} MB/s';
    } else if (speedInBytes >= KB) {
      return '${(speedInBytes / KB).toStringAsFixed(2)} KB/s';
    } else if (speedInBytes == 0) {
      return '';
    } else {
      return '$speedInBytes B/s';
    }
  }
}

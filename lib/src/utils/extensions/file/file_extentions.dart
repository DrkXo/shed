// ignore_for_file: constant_identifier_names

abstract class FileSizeFormatter {
  static String format(int sizeInBytes) {
    const int KB = 1024;
    const int MB = 1024 * KB;
    const int GB = 1024 * MB;
    const int TB = 1024 * GB;

    if (sizeInBytes >= TB) {
      return '${(sizeInBytes / TB).toStringAsFixed(2)} TB';
    } else if (sizeInBytes >= GB) {
      return '${(sizeInBytes / GB).toStringAsFixed(2)} GB';
    } else if (sizeInBytes >= MB) {
      return '${(sizeInBytes / MB).toStringAsFixed(2)} MB';
    } else if (sizeInBytes >= KB) {
      return '${(sizeInBytes / KB).toStringAsFixed(2)} KB';
    } else {
      return '$sizeInBytes Bytes';
    }
  }
}

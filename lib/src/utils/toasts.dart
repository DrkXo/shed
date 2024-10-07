import 'package:flutter/material.dart';

/// Helper function to show custom toast notifications
void showDownloadNotification(
  String message,
  IconData icon,
  Color backgroundColor,
) {}

/// Show download start notification
void showDownloadStartNotification() {
  showDownloadNotification(
    "Download started...",
    Icons.cloud_download,
    Colors.blue,
  );
}

/// Show download complete notification
void showDownloadCompleteNotification() {
  showDownloadNotification(
    "Download complete!",
    Icons.cloud_done,
    Colors.green,
  );
}

/// Show download error notification
void showDownloadErrorNotification() {
  showDownloadNotification(
    "Download failed. Try again.",
    Icons.error,
    Colors.red,
  );
}

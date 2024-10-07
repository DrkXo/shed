import 'package:aria2cf/aria2cf.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class NotificationService {
  void showAria2NotificationToast(
    Aria2NotificationType type,
    String gid,
  ) {
    // Determine the message, icon, and color based on the notification type
    String message;
    IconData icon;
    Color backgroundColor;

    switch (type) {
      case Aria2NotificationType.downloadStart:
        message = 'Download started: GID $gid';
        icon = Icons.download;
        backgroundColor = Colors.blueAccent;
        break;
      case Aria2NotificationType.downloadPause:
        message = 'Download paused: GID $gid';
        icon = Icons.pause_circle_filled;
        backgroundColor = Colors.orangeAccent;
        break;
      case Aria2NotificationType.downloadStop:
        message = 'Download stopped: GID $gid';
        icon = Icons.stop_circle;
        backgroundColor = Colors.redAccent;
        break;
      case Aria2NotificationType.downloadComplete:
        message = 'Download completed: GID $gid';
        icon = Icons.check_circle;
        backgroundColor = Colors.greenAccent;
        break;
      case Aria2NotificationType.downloadError:
        message = 'Download error: GID $gid';
        icon = Icons.error;
        backgroundColor = Colors.red;
        break;
      case Aria2NotificationType.btDownloadComplete:
        message = 'BitTorrent download completed: GID $gid';
        icon = Icons.check_circle_outline;
        backgroundColor = Colors.purpleAccent;
        break;
      case Aria2NotificationType.unknown:
        return;
    }

    // Show the BotToast notification
    BotToast.showCustomText(
      duration: Duration(seconds: 3),
      toastBuilder: (context) => Card(
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

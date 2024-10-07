part of "providers_index.dart";

@riverpod
Future<void> notification(NotificationRef ref) async {
  final NotificationService notificationService = NotificationService();
  final notification = ref.watch(aria2cSocketProvider);

  notification.notificationStreamStream.listen(
    (Aria2Notification onData) {
      logger.i(onData);
      notificationService.showAria2NotificationToast(
        onData.notificationType,
        onData.params.toString(),
      );
    },
  );
}

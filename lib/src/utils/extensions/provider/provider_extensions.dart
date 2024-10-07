// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void schedulePeriodicRequest({
  required Duration interval,
  required Function() requestCallback,
  required Ref ref,
}) {
  Timer? _timer;

  // Start periodic task
  ref.onAddListener(() {
    _timer = Timer.periodic(interval, (timer) {
      requestCallback();
    });
  });

  // Cancel timer when the listener is removed
  ref.onRemoveListener(() {
    _timer?.cancel();
  });
}

void handleSocketStream<T>({
  required Stream<dynamic> dataStream,
  required Function(T) onDataCallback,
  Function(T)? onErrorCallback,
  Function? onDoneCallback,
  required Ref ref,
}) {
  final subscription = dataStream.listen(
    (onData) {
      if (onData is T) {
        onDataCallback(onData);
      }
    },
    onError: (onError) {
      if (onError is T && onErrorCallback != null) {
        onDataCallback(onError);
      }
    },
    onDone: () {
      if (onDoneCallback != null) {
        onDoneCallback();
      }
    },
  );

  ref.onDispose(() {
    subscription.cancel();
  });
}

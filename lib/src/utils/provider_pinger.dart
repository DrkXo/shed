// Extracted pulse method
import 'package:aria2cf/aria2cf.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shed/src/providers/providers_index.dart';

void aria2cSocketPinger({
  required Ref ref,
  required ProviderBase<Object?> self,
  required Aria2cRequest req,
}) async {
  final socket = ref.read(aria2cSocketProvider);
  while (ref.exists(self)) {
    await Future.delayed(const Duration(seconds: 1));
    socket.sendData(
      request: req,
    );
  }
}

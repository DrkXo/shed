part of '../providers_index.dart';

@riverpod
Aria2cSocket aria2cSocket(Aria2cSocketRef ref) {
  final socket = Aria2cSocket();
  ref.onAddListener(() {
    socket.dataStream.listen((onData) {
      //logger.i(onData);
    });
  });
  return socket;
}

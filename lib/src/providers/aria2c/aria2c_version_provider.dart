part of "../providers_index.dart";

@riverpod
Stream<Aria2cVersion> aria2cVersion(Aria2cVersionRef ref) {
  final socket = ref.watch(aria2cSocketProvider);

  ref.onAddListener(
    () => aria2cSocketPinger(
      ref: ref,
      self: aria2cActiveTasksProvider,
      req: Aria2cRequest.getVersion(
        secret: Env.aria2cSecret,
      ),
    ),
  );

  return socket.aria2cVersionStream;
}

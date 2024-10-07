part of "../providers_index.dart";

@riverpod
Stream<Aria2cGlobalStat> aria2cGlobalStat(Aria2cGlobalStatRef ref) {
  final socket = ref.watch(aria2cSocketProvider);

  ref.onAddListener(
    () => aria2cSocketPinger(
      ref: ref,
      self: aria2cGlobalStatProvider,
      req: Aria2cRequest.getGlobalStat(
        secret: Env.aria2cSecret,
      ),
    ),
  );

  return socket.aria2cGlobalStatStream;
}

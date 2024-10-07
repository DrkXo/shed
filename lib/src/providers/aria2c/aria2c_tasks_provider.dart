part of "../providers_index.dart";

@riverpod
Stream<List<Aria2cTask>> aria2cActiveTasks(Aria2cActiveTasksRef ref) {
  final socket = ref.watch(aria2cSocketProvider);

  ref.onAddListener(
    () => aria2cSocketPinger(
      ref: ref,
      self: aria2cActiveTasksProvider,
      req: Aria2cRequest.tellActive(
        secret: Env.aria2cSecret,
      ),
    ),
  );

  return socket.aria2cActiveTasksStream;
}

@riverpod
Stream<List<Aria2cTask>> aria2cWaitingTasks(Aria2cWaitingTasksRef ref) {
  final socket = ref.watch(aria2cSocketProvider);

  ref.onAddListener(
    () => aria2cSocketPinger(
      ref: ref,
      self: aria2cWaitingTasksProvider,
      req: Aria2cRequest.tellWaiting(
        secret: Env.aria2cSecret,
        offset: 0,
        count: 4,
      ),
    ),
  );
  return socket.aria2cWaitingTasksStream;
}

@riverpod
Stream<List<Aria2cTask>> aria2cStoppedTasks(Aria2cStoppedTasksRef ref) {
  final socket = ref.watch(aria2cSocketProvider);

  ref.onAddListener(
    () => aria2cSocketPinger(
      ref: ref,
      self: aria2cStoppedTasksProvider,
      req: Aria2cRequest.tellStopped(
        secret: Env.aria2cSecret,
        offset: 0,
        count: 4,
      ),
    ),
  );
  return socket.aria2cCompletedTasksStream;
}

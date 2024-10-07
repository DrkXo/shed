part of "providers_index.dart";

class InitializationState extends Equatable {
  final List<String> messages;
  final List<bool> results;
  final bool hasError;
  final String? errorMessage;
  final double progress;
  final bool isLoading;

  const InitializationState({
    this.messages = const [],
    this.results = const [],
    this.hasError = false,
    this.errorMessage,
    this.progress = 0.0,
    this.isLoading = false,
  });

  bool get isComplete =>
      results.isNotEmpty && results.every((result) => result) && !hasError;

  InitializationState copyWith({
    List<String>? messages,
    List<bool>? results,
    bool? hasError,
    String? errorMessage,
    double? progress,
    bool? isLoading,
  }) {
    return InitializationState(
      messages: messages ?? this.messages,
      results: results ?? this.results,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props =>
      [messages, results, hasError, errorMessage, progress, isLoading];
}

@riverpod
class InItNotifier extends _$InItNotifier {
  @override
  FutureOr<InitializationState> build() {
    ref.onDispose(_cleanUP);

    state = AsyncValue.loading();
    return const InitializationState(
      messages: [],
      isLoading: true,
    );
  }

  Future<void> initialize() async {
    if (state.isLoading) return; // Prevent multiple initializations

    state = const AsyncValue.loading(); // Show loading state
    List<bool> results = [];

    try {
      // Update state with progress message
      state = AsyncValue.data(
        state.value?.copyWith(
              progress: 0.0,
              messages: ["Starting initialization..."],
              isLoading: true,
            ) ??
            const InitializationState(isLoading: true),
      );

      // Execute initialization steps in sequence
      await _runInitializationStep(
        service: ref.watch(sharedPrefServiceProvider.future),
        message: 'Cache Initialized...',
        results: results,
      );

      await _runInitializationStep(
        service: ref.watch(aria2cServerConfigurationProvider.future),
        message: 'Configuration Initialized...',
        results: results,
      );

      await _runInitializationStep(
        service: ref.watch(aria2cRpcServerProvider.future),
        message: 'Engine Started...',
        results: results,
      );

      await _runInitializationStep(
        service: ref.watch(aria2cSocketProvider).connect(),
        message: 'Connecting to Engine...',
        results: results,
      );

      await _runInitializationStep(
        service: ref.watch(trayServiceProvider.future),
        message: 'System Tray Initialized...',
        results: results,
      );

      await _runInitializationStep(
         service: ref.watch(notificationProvider.future),
        message: 'Notification Service Initialized...',
        results: results,
      );

      // Update state once all steps are complete
      state = AsyncValue.data(
        state.value!.copyWith(
          results: results,
          isLoading: false,
        ),
      );
    } catch (e, s) {
      // Handle errors by updating the state with error information
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> _runInitializationStep({
    required Future<void> service,
    required String message,
    required List<bool> results,
  }) async {
    await service; // Await the initialization service

    // Update the state with progress
    state = AsyncValue.data(
      state.value!.copyWith(
        progress:
            (state.value!.progress + 1).clamp(0, 4), // Clamp to total steps
        messages: [...state.value!.messages, message],
      ),
    );

    results.add(true); // Mark step as successful
  }

  Future<void> _cleanUP() async {
    // Cleanup services when notifier is disposed
    ref.invalidate(sharedPrefServiceProvider);
    ref.invalidate(aria2cServerConfigurationProvider);
    ref.invalidate(aria2cRpcServerProvider);
    ref.invalidate(aria2cSocketProvider);
    //ref.invalidate(trayServiceProvider);
  }
}

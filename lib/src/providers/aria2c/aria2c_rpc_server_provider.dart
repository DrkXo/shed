part of '../providers_index.dart';

@riverpod
class Aria2cRpcServer extends _$Aria2cRpcServer {
  late Aria2cServerConfig _serverConfig;
  late ProcessManager _processManager;
  Aria2cRpcService? _aria2cRpcService;

  @override
  Future<Aria2cRpcService> build() async {
    try {
      // Fetch the server configuration
      _serverConfig = await ref.watch(aria2cServerConfigurationProvider.future);

      // Initialize the process manager
      _processManager = LocalProcessManager();

      // Initialize Aria2cRpcService
      _aria2cRpcService = Aria2cRpcService(
        serverConfig: _serverConfig,
        processManager: _processManager,
      );

      // Attempt to start the service
      await _aria2cRpcService!.tryStart(killIfFound: false);

      // Keep the service alive
      ref.keepAlive();

      // Ensure proper disposal of the service
      ref.onDispose(() async {
        await _aria2cRpcService?.stop();
      });

      return _aria2cRpcService!;
    } catch (e, stackTrace) {
      // Log the error and rethrow it for proper error handling
      logger.e('Failed to initialize Aria2cRpcService: $e',
          error: e, stackTrace: stackTrace);
      throw Exception('Error initializing Aria2cRpcService: $e');
    }
  }

  // Method to handle retries on initialization failure
  Future<void> retryInitialization() async {
    try {
      if (_aria2cRpcService != null) {
        await _aria2cRpcService!
            .stop(); // Stop any running instance before retrying
      }
      state = const AsyncLoading(); // Reset the state to loading
      await build(); // Retry the build method
    } catch (e, s) {
      logger.e('Retry failed: $e');
      state = AsyncError(e, s); // Set the state to error if retry fails
    }
  }
}

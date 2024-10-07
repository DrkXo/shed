import 'package:aria2cf/aria2cf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process/process.dart';
import 'package:shed/server/aria2c_rpc_service.dart';
import 'package:shed/server/models/aria2c_server_config.dart';
import 'package:shed/src/utils/logger.dart';

class Aria2cServices {
  late Aria2cSocket socket;
  late Aria2cServerConfig serverConfig;
  late Aria2cRpcService aria2cService;
  final ProcessManager _processManager = LocalProcessManager();

  Future<void> initialize() async {
    logger.i('Aria2cServices Started....');

    final dir = await getDownloadsDirectory();

    serverConfig = Aria2cServerConfig(
      dir: dir!.path,
    );

    socket = Aria2cSocket();
    aria2cService = Aria2cRpcService(
      serverConfig: serverConfig,
      processManager: _processManager,
    );

    // Try to start aria2c, killing any existing process if found
    String? pid = await aria2cService.tryStart(killIfFound: true);

    if (pid != null) {
      logger.i('aria2c started with PID: $pid');

      // Retry mechanism for socket connection
      await _attemptSocketConnection();
    } else {
      throw 'Unable to start aria2 service!';
    }

    logger.i('Aria2cServices Finished....');
  }

  /// Retry mechanism for socket connection
  Future<void> _attemptSocketConnection({
    int maxAttempts = 5,
    Duration retryDelay = const Duration(seconds: 5),
  }) async {
    int attempt = 0;

    while (attempt < maxAttempts) {
      try {
        // Attempt to connect the socket
        await socket.connect();
        logger.i('Socket connected successfully on attempt ${attempt + 1}');
        return; // Exit once connected
      } catch (e) {
        attempt++;
        logger.w('Socket connection attempt $attempt failed: $e');

        if (attempt < maxAttempts) {
          logger.i(
              'Retrying socket connection in ${retryDelay.inSeconds} seconds...');
          await Future.delayed(retryDelay);
        } else {
          logger.e('Max attempts reached. Could not connect to socket.');
          throw Exception(
              'Failed to connect to aria2c socket after $maxAttempts attempts: $e');
        }
      }
    }
  }

  Future<void> dispose() async {
    socket.disconnect();
    aria2cService.dispose();
    //await aria2cService.findAndKillAria2cProcess(killIfFound: true);
  }
}

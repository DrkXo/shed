import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:process/process.dart';
import 'package:shed/constants/constants.dart';
import 'package:shed/server/aria2c_binary_service.dart';
import 'package:shed/server/models/aria2c_server_config.dart';
import 'package:shed/src/utils/logger.dart';

class Aria2cRpcService {
  final Aria2cBinaryService _binaryPath = Aria2cBinaryService();
  final Aria2cServerConfig _serverConfig;
  final ProcessManager _processManager;

  Process? _aria2cProcess;
  // ignore: unused_field
  int? _processGroupId;
  Completer<void>? _startCompleter;
  Completer<void>? _stopCompleter;

  Aria2cRpcService({
    required Aria2cServerConfig serverConfig,
    required ProcessManager processManager,
  })  : _serverConfig = serverConfig,
        _processManager = processManager;

  List<String> get _arguments => [
        '--enable-rpc',
        '--rpc-listen-all=false',
        '--rpc-allow-origin-all',
        '--rpc-listen-port=6800',
        '--rpc-secret=${Env.aria2cSecret}',
        '--dir=${_serverConfig.dir}',
      ];

  Future<String?> tryStart({bool killIfFound = false}) async {
    if (_startCompleter != null && !_startCompleter!.isCompleted) {
      return _startCompleter!.future
          .then((_) => _aria2cProcess?.pid.toString());
    }

    _startCompleter = Completer<void>();
    try {
      final pid = await findAria2cProcess();
      if (pid != null) {
        if (killIfFound) {
          //await findAndKillAria2cProcess(killIfFound: killIfFound);
          await Future.delayed(const Duration(milliseconds: 500));
        } else {
          logger.i(
              'Found running aria2c process with PID: $pid, skipping start.');
          _startCompleter!.complete();
          return pid;
        }
      }

      final aria2cBinary = await _binaryPath.getAria2cBinaryPath();
      if (aria2cBinary == null) {
        final errorMessage =
            'Could not locate aria2c binary for this platform.';
        logger.e(errorMessage);
        _startCompleter!.completeError(Exception(errorMessage));
        throw Exception(errorMessage);
      }

      final aria2cConfig = await _binaryPath.getAria2cConfigPath();
      final workingDirectory = path.dirname(aria2cBinary);

      var args = [
        ..._arguments,
        if (aria2cConfig != null) '--conf-path=$aria2cConfig',
      ];

      logger.i(
          'Starting aria2c process: $aria2cBinary $args \n in $workingDirectory');

      // Start the aria2c process
      _aria2cProcess = await _processManager.start(
        [aria2cBinary, ...args],
        workingDirectory: workingDirectory,
      );

      _processGroupId =
          _aria2cProcess!.pid; // Save process group ID for future use

      await _monitorProcess(_aria2cProcess!);

      logger.i('aria2c RPC server started with PID: ${_aria2cProcess!.pid}');
      _startCompleter!.complete();
      return _aria2cProcess!.pid.toString();
    } catch (e) {
      logger.e('Failed to start aria2c: $e');
      _startCompleter!.completeError(e);
      throw Exception('Failed to start aria2c: $e');
    }
  }

  Future<void> stop() async {
    if (_aria2cProcess == null) {
      final errorMessage = 'No aria2c process is running to stop.';
      logger.i(errorMessage);
      throw Exception(errorMessage);
    }

    if (_stopCompleter != null && !_stopCompleter!.isCompleted) {
      return _stopCompleter!.future;
    }

    _stopCompleter = Completer<void>();
    try {
      logger.i(
          'Attempting to stop aria2c process with PID: ${_aria2cProcess!.pid}');
      bool killed = _aria2cProcess!.kill();

      if (killed) {
        logger.i(
            'Successfully stopped aria2c process with PID: ${_aria2cProcess!.pid}');
        _aria2cProcess = null;
        _stopCompleter!.complete();
      } else {
        final errorMessage =
            'Failed to stop aria2c process with PID: ${_aria2cProcess!.pid}';
        logger.e(errorMessage);
        _stopCompleter!.completeError(Exception(errorMessage));
        throw Exception(errorMessage);
      }
    } catch (e) {
      logger.e('Error stopping aria2c process: $e');
      _stopCompleter!.completeError(e);
      throw Exception('Error stopping aria2c process: $e');
    }
  }

  Future<void> _monitorProcess(Process process) async {
    Completer<void> completer = Completer<void>();
    const Duration timeoutDuration =
        Duration(seconds: 5); // Allow more time to start
    bool positiveOutputReceived = false;

    process.stdout.transform(SystemEncoding().decoder).listen((data) {
      logger.i('aria2c stdout: $data');
      if (data.contains('RPC server started')) {
        // Look for confirmation message
        positiveOutputReceived = true;
        completer.complete();
      }
    });

    process.stderr.transform(SystemEncoding().decoder).listen((data) {
      logger.i('aria2c stderr: $data');
      if (!completer.isCompleted) {
        completer.completeError(Exception('Error from aria2c: $data'));
      }
    });

    process.exitCode.then((code) {
      logger.i('aria2c process exited with code: $code');
      if (!completer.isCompleted) {
        completer
            .completeError(Exception('aria2c process exited unexpectedly.'));
      }
      _aria2cProcess = null;
    });

    // Wait for either the completer or timeout
    await Future.any([
      completer.future,
      Future.delayed(timeoutDuration, () {
        if (!positiveOutputReceived) {
          completer
              .completeError(Exception('Timeout waiting for aria2c output.'));
        }
      }),
    ]);
  }

  Future<String?> findAria2cProcess() async {
    try {
      final result = await _processManager.run(
        Platform.isWindows ? ['tasklist'] : ['ps', 'aux'],
      );

      if (result.exitCode == 0) {
        final processes = result.stdout.toString().split('\n').where((line) {
          return line.contains(Platform.isWindows ? 'aria2c.exe' : 'aria2c');
        });

        if (processes.isNotEmpty) {
          final pid = processes.first.split(RegExp(r'\s+'))[1];
          logger.i('Found running aria2c process with PID: $pid');
          return pid;
        } else {
          logger.i('No running aria2c process found.');
        }
      } else {
        final errorMessage = 'Error running process command: ${result.stderr}';
        logger.i(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      logger.e('Error finding aria2c process: $e');
      throw Exception('Error finding aria2c process: $e');
    }
    return null;
  }

  Future<void> killProcessByPid(String pid) async {
    try {
      logger.i('Attempting to kill aria2c process with PID: $pid');
      ProcessResult killResult;

      if (Platform.isWindows) {
        killResult = await _processManager.run(['taskkill', '/PID', pid, '/F']);
      } else {
        killResult = await _processManager.run(['kill', pid]);
        if (killResult.exitCode != 0) {
          logger.w('Failed to gracefully stop, forcing termination');
          killResult = await _processManager.run(['kill', '-9', pid]);
        }
      }

      if (killResult.exitCode == 0) {
        logger.i('Successfully killed aria2c process with PID: $pid');
      } else {
        final errorMessage =
            'Failed to kill aria2c process with PID: $pid, error: ${killResult.stderr}';
        logger.e(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      logger.e('Error while killing process with PID $pid: $e');
      throw Exception('Error while killing process with PID $pid: $e');
    }
  }

  // New method to check if the process is running
  Future<bool> isRunning() async {
    return _aria2cProcess != null && _aria2cProcess!.pid != 0;
  }

  void dispose() {
    stop(); // Ensure process is stopped when this service is disposed
  }
}

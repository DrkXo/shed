import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shed/constants/constants.dart';
import 'package:shed/src/utils/logger.dart';

class Aria2cBinaryService {
  final String platform = Platform.operatingSystem;
  final String _android = 'assets/aria2c/android/aria2c';
  final String _linux = 'assets/aria2c/linux/x64/aria2c';
  final String _windows = 'assets/aria2c/windows/x64/aria2c.exe';
  final String _macos = 'assets/aria2c/macos/aria2c';
  final String _configAssetPath = 'assets/aria2c/config/aria2.conf';
  final String _binaryDirName = '${Env.appName}/aria2c';
  final String _configDirName = '${Env.appName}/aria2c';

  /// Public method to retrieve the aria2c binary path based on the platform
  Future<String?> getAria2cBinaryPath() async {
    try {
      String assetPath = _getBinaryAssetPath();
      if (assetPath.isEmpty) return null;

      await _setupDirectories();

      final directory = await _getWritableDirectory();
      final binaryPath = _buildBinaryPath(directory.path, assetPath);

      return await _handleBinaryFile(binaryPath, assetPath);
    } catch (e) {
      _logError('Failed to retrieve aria2c binary path: $e');
      return null;
    }
  }

  /// Public method to retrieve the aria2c configuration file path
  Future<String?> getAria2cConfigPath() async {
    try {
      await _setupDirectories();

      final directory = await _getWritableDirectory();
      final configPath =
          path.join(directory.path, _configDirName, 'aria2c.conf');

      return await _handleConfigFile(configPath);
    } catch (e) {
      _logError('Failed to retrieve aria2c configuration path: $e');
      return null;
    }
  }

  /// Determines the appropriate asset path for the binary based on the platform
  String _getBinaryAssetPath() {
    switch (platform) {
      case 'windows':
        return _windows;
      case 'linux':
        return _linux;
      case 'macos':
        return _macos;
      case 'android':
        return _android;
      default:
        _logError('Unsupported platform: $platform');
        return '';
    }
  }

  /// Sets up the necessary directories for binaries and configuration
  Future<void> _setupDirectories() async {
    final writableDir = await _getWritableDirectory();

    await _createDirectoryIfNeeded(path.join(writableDir.path, _binaryDirName));
    await _createDirectoryIfNeeded(path.join(writableDir.path, _configDirName));
  }

  /// Creates a directory if it doesn't already exist
  Future<void> _createDirectoryIfNeeded(String dirPath) async {
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
      _logInfo('Directory created: $dirPath');
    }
  }

  /// Handles the binary file: if it exists, return the path, otherwise, extract it from assets
  Future<String> _handleBinaryFile(String binaryPath, String assetPath) async {
    final binaryFile = File(binaryPath);

    if (await binaryFile.exists()) {
      _logInfo('Binary already exists at: $binaryPath');
    } else {
      final byteData = await rootBundle.load(assetPath);
      await _writeFile(binaryFile, byteData.buffer.asUint8List());

      if (!Platform.isWindows) {
        await _makeFileExecutable(binaryPath);
      }

      _logInfo('Binary copied to: $binaryPath');
    }

    return binaryPath;
  }

  /// Handles the configuration file: if it exists, return the path, otherwise, extract it from assets
  Future<String> _handleConfigFile(String configPath) async {
    final configFile = File(configPath);

    if (await configFile.exists()) {
      _logInfo('Configuration file already exists at: $configPath');
    } else {
      final configData = await rootBundle.loadString(_configAssetPath);
      await _writeStringFile(configFile, configData);
      _logInfo('Configuration file copied to: $configPath');
    }

    return configPath;
  }

  /// Makes the binary file executable on Unix-like platforms
  Future<void> _makeFileExecutable(String filePath) async {
    await Process.run('chmod', ['+x', filePath]);
    _logInfo('Made executable: $filePath');
  }

  /// Writes binary data to the file
  Future<void> _writeFile(File file, Uint8List data) async {
    await file.create(recursive: true);
    await file.writeAsBytes(data, flush: true);
  }

  /// Writes string data to the file
  Future<void> _writeStringFile(File file, String data) async {
    await file.create(recursive: true);
    await file.writeAsString(data, flush: true);
  }

  /// Gets the writable directory for binary and config storage
  Future<Directory> _getWritableDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Builds the full binary file path
  String _buildBinaryPath(String dirPath, String assetPath) {
    String fileName = Platform.isWindows ? 'aria2c.exe' : 'aria2c';
    return path.join(dirPath, _binaryDirName, fileName);
  }

  /// Logs errors
  void _logError(String message) {
    logger.i(message);
  }

  /// Logs information messages
  void _logInfo(String message) {
    logger.i(message);
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferences? _prefs;

  SharedPreferencesService();

  /// Initializes the SharedPreferences instance
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Disposes of SharedPreferences instance by nullifying it
  Future<void> dispose() async {
    _prefs = null;
  }

  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }

  Future<void> saveThemeMode(String themeMode) async {
    await _prefs?.setString('theme_mode', themeMode);
  }

  String? getThemeMode() {
    return _prefs?.getString('theme_mode');
  }
}

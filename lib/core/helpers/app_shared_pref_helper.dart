import 'package:draya_mobile/core/constants/app_shared_pref_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class AppSharedPrefHelper {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Removes a value from SharedPreferences with given [key].
  static Future<void> removeData(String key) async {
    await _sharedPreferences.remove(key);
  }

  /// Removes all keys and values in the SharedPreferences
  static Future<void> clearAllData() async {
    await _sharedPreferences.clear();
  }

  /// Saves a [value] with a [key] in the SharedPreferences.
  static Future<void> setData(String key, dynamic value) async {
    switch (value.runtimeType) {
      case const (String):
        await _sharedPreferences.setString(key, value);
      case const (int):
        await _sharedPreferences.setInt(key, value);
      case const (bool):
        await _sharedPreferences.setBool(key, value);
      case const (double):
        await _sharedPreferences.setDouble(key, value);
    }
  }

  /// Gets a bool value from SharedPreferences with given [key].
  static bool? getBool(String key) {
    return _sharedPreferences.getBool(key);
  }

  /// Gets a double value from SharedPreferences with given [key].
  static double? getDouble(String key) {
    return _sharedPreferences.getDouble(key);
  }

  /// Gets an int value from SharedPreferences with given [key].
  static int? getInt(String key) {
    return _sharedPreferences.getInt(key);
  }

  /// Gets an String value from SharedPreferences with given [key].
  static String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  /// Saves a [value] with a [key] in the FlutterSecureStorage.
  static Future<void> setSecuredString(String key, String value) async {
    const flutterSecureStorage = FlutterSecureStorage();
    await flutterSecureStorage.write(key: key, value: value);
  }

  /// Gets an String value from FlutterSecureStorage with given [key].
  static Future<String?>? getSecuredString(String key) async {
    const flutterSecureStorage = FlutterSecureStorage();
    try {
      return await flutterSecureStorage.read(key: key) ?? '';
    } catch (e) {
      await flutterSecureStorage.deleteAll();
      return null;
    }
  }

  /// Removes all keys and values in the FlutterSecureStorage
  static Future<void> clearAllSecuredData() async {
    const flutterSecureStorage = FlutterSecureStorage();
    await flutterSecureStorage.deleteAll();
  }

  static String getLanguage() {
    return getString(AppSharedPrefKeys.language) ?? "en";
  }

  static Future<String> toggleLanguage() async {
    final language = getLanguage();
    final otherLanguage = language == "en" ? "ar" : "en";
    await setData(AppSharedPrefKeys.language, otherLanguage);
    return otherLanguage;
  }
}

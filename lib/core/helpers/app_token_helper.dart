import '../constants/app_shared_pref_keys.dart';
import 'app_shared_pref_helper.dart';

abstract final class AppTokenHelper {
  static bool isLoggedIn = false;
  static Future<bool> isSignedIn() async {
    final token = await _getToken();
    isLoggedIn = token != null && token.isNotEmpty;
    return isLoggedIn;
  }

  static Future<String?> _getToken() async {
    return await AppSharedPrefHelper.getSecuredString(
      AppSharedPrefKeys.userToken,
    );
  }

  static Future<String?> getAccessToken() => _getToken();

  static Future<String?> getUserRole() async {
    return AppSharedPrefHelper.getString(AppSharedPrefKeys.userRole);
  }

  static Future<void> clearSessionIfNotRemembered() async {
    final remembered =
        AppSharedPrefHelper.getBool(AppSharedPrefKeys.rememberMe) ?? false;
    if (!remembered) {
      await AppSharedPrefHelper.clearAllSecuredData();
      await AppSharedPrefHelper.removeData(AppSharedPrefKeys.userRole);
    }
  }
}

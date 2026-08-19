import "../constants/app_shared_pref_keys.dart";
import "app_shared_pref_helper.dart";

abstract final class AppTokenHelper {
  static bool isLoggedIn = false;

  static Future<String?> getAccessToken() async {
    final token = await AppSharedPrefHelper.getSecuredString(
      AppSharedPrefKeys.accessToken,
    );

    if (token == null || token.isEmpty) {
      return null;
    }

    return token;
  }

  static Future<String?> getRefreshToken() async {
    final token = await AppSharedPrefHelper.getSecuredString(
      AppSharedPrefKeys.refreshToken,
    );

    if (token == null || token.isEmpty) {
      return null;
    }

    return token;
  }

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await AppSharedPrefHelper.setSecuredString(
      AppSharedPrefKeys.accessToken,
      accessToken,
    );

    await AppSharedPrefHelper.setSecuredString(
      AppSharedPrefKeys.refreshToken,
      refreshToken,
    );

    isLoggedIn = true;
  }

  static Future<void> clearTokens() async {
    await AppSharedPrefHelper.clearAllSecuredData();

    isLoggedIn = false;
  }

  static Future<void> isSignedIn() async {
    final refreshToken = await getRefreshToken();

    isLoggedIn = refreshToken != null && refreshToken.isNotEmpty;
  }

  static Future<String?> getUserRole() async {
    return AppSharedPrefHelper.getString(
      AppSharedPrefKeys.userRole,
    );
  }

  static Future<void> clearSessionIfNotRemembered() async {
    final remembered =
        AppSharedPrefHelper.getBool(AppSharedPrefKeys.rememberMe) ?? false;

    if (!remembered) {
      await clearTokens();
      await AppSharedPrefHelper.removeData(
        AppSharedPrefKeys.userRole,
      );
    }
  }
}

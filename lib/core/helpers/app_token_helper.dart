import '../constants/app_shared_pref_keys.dart';
import 'app_shared_pref_helper.dart';

abstract final class AppTokenHelper {
  static Future<bool> isSignedIn() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<String?> _getToken() async {
    return await AppSharedPrefHelper.getSecuredString(
      AppSharedPrefKeys.userToken,
    );
  }
}

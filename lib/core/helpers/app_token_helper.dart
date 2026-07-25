import '../constants/app_shared_pref_keys.dart';
import 'app_extensions.dart';
import 'app_shared_pref_helper.dart';

class AppTokenHelper {
  static bool isLoggedInUser = false;
  static Future<void> checkIfLoggedInUser() async {
    String? userToken = await AppSharedPrefHelper.getSecuredString(
      AppSharedPrefKeys.userToken,
    );

    if (!userToken.isNullOrEmpty()) {
      isLoggedInUser = true;
    } else {
      isLoggedInUser = false;
    }
  }
}

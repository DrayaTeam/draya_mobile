import 'package:draya_mobile/core/helpers/app_regex_helper.dart';

abstract class AppRegex {
  static bool isEmailValid(String email) {
    return AppRegexHelper.emailValidatorRegExp.hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return AppRegexHelper.passwordValidatorRegExp.hasMatch(password);
  }

  static bool hasMinLength(String password) {
    return RegExp(r'^(?=.{8,})').hasMatch(password);
  }
}

import 'package:draya_mobile/core/helpers/app_regex_helper.dart';
import 'package:draya_mobile/core/validation/validation_result.dart';

abstract class PhoneValidator {
  static ValidationResult validate({required String? phone}) {
    if (phone == null || phone.isEmpty) {
      return Invalid(message: "Phone is required");
    }
    if (AppRegexHelper.phoneValidatorRegExp.hasMatch(phone) == false) {
      return Invalid(message: "Phone is invalid");
    }

    return Valid();
  }
}

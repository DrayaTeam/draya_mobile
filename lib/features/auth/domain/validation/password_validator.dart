import 'package:draya_mobile/core/helpers/app_regex.dart';
import 'package:draya_mobile/features/auth/domain/validation/validation_result.dart';

abstract class PasswordValidator {
  static ValidationResult validate({required String? password}) {
    if (password == null) {
      return Invalid(message: "Password is required");
    }

    password = password.trim();

    if (password.isEmpty) {
      return Invalid(message: "Password is required");
    } else if (!AppRegex.isPasswordValid(password)) {
      return Invalid(
        message:
            "Password must be at least 8 characters and includes one uppercase letter, one lowercase letter, one number, and one special character.",
      );
    }

    return Valid();
  }
}

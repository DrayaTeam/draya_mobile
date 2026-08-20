import "package:draya_mobile/core/validation/validation_result.dart";

abstract class EmailValidator {
  static ValidationResult validate({required String? email}) {
    if (email == null) {
      return Invalid(message: "Email is required");
    }
    email = email.trim();

    if (email.isEmpty) {
      return Invalid(message: "Email is required");
    }

    final regex = RegExp(r"^\w+@\w+.\w+$");

    if (!regex.hasMatch(email)) {
      return Invalid(message: "Invalid email");
    }

    return Valid();
  }
}

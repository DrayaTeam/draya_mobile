abstract final class AppRegexHelper {
  /// Regex for validating emails.
  static final RegExp emailValidatorRegExp = RegExp(
    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  /// Regex for validating if the string contains only numbers.
  static final RegExp numberValidatorRegExp = RegExp(r'^[0-9]+$');

  /// Regex for password validation.
  /// Requires at least 8 characters, one uppercase letter, one lowercase letter,
  /// one number, and one special character.
  static final RegExp passwordValidatorRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!+%*?&-])[A-Za-z\d@$!+%-*?&]{8,}$',
  );
}

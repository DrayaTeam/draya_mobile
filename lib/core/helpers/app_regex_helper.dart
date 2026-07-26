abstract class AppRegexHelper {
  /// Regex for validating emails.
  static final RegExp emailValidatorRegExp = RegExp(
    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  /// Regex for validating names (allows only letters and spaces).
  //static final RegExp nameValidatorRegExp = RegExp(r'^[a-zA-Z\s]+$');

  /// Regex for validating phone numbers.
  /// This example is for a general format, you might want to adjust it.
  /// e.g., for saudi numbers: ^(05|5|\\+9665)[0-9]{8}$
  static final RegExp phoneValidatorRegExp = RegExp(r'^(05|5|\9665)[0-9]{8}$');

  /// Regex for validating if the string contains only numbers.
  static final RegExp numberValidatorRegExp = RegExp(r'^[0-9]+$');

  /// Regex for password validation.
  /// Requires at least 8 characters, one uppercase letter, one lowercase letter,
  /// one number, and one special character.
  static final RegExp passwordValidatorRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!+%*?&-])[A-Za-z\d@$!+%-*?&]{8,}$',
  );
}

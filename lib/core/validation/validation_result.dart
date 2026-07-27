sealed class ValidationResult {}

class Valid extends ValidationResult {}

class Invalid extends ValidationResult {
  final String message;

  Invalid({required this.message});
}

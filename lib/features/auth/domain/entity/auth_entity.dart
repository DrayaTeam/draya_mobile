class AuthEntity {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });
}

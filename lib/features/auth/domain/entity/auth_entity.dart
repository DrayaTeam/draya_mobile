class AuthEntity {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserRoleEntity? user;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.user,
  });
}

class UserRoleEntity {
  final String fullName;
  final String role;

  const UserRoleEntity({
    required this.fullName,
    required this.role,
  });
}

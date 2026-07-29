enum UserRole {
  student,
  teacher;

  String get displayName => switch (this) {
    UserRole.student => "Student",
    UserRole.teacher => "Teacher",
  };

  static UserRole fromName({required String name}) {
    return UserRole.values.firstWhere((role) => role.name == name);
  }
}

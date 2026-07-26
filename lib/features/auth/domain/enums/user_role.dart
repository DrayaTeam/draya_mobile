enum UserRole {
  student(name: "Student"),
  teacher(name: "Teacher");

  final String name;
  const UserRole({required this.name});
}

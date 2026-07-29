abstract final class AppRoutes {
  static const String homePage = "/";
  static const String userRoleParameter = "userRole";
  static const String signinPage = "/signin/:$userRoleParameter";
  static const String studentSignupPage = "/studentSignup";
  static const String teacherSignupPage = "/teacherSignup";
  static const String mainPage = "/main";
}

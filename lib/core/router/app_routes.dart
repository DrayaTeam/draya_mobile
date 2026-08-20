abstract final class AppRoutes {
  static const String signupChoice = "/signup_choice";
  static const String signinPage = "/signin";
  static const String signupPage = "/signup";
  static const String mainPage = "/main";
  static const String verificationCodePage = "/verification_code";
  static const String teacherDashboardPage = "/teacher_dashboard";
  static const String studentHomePage = "/student_home";
  static const String examGenerationPage1 = "/teacher/exam/generate/step_1";
  static const String examGenerationPage2 = "/teacher/exam/generate/step_2";
  static const String examGenerationPage3 = "/teacher/exam/generate/step_3";
  static const String studentsListPage = "/teacher/student_list";
  static const String subjectsPage = "/teacher/subjects";
  static const String classroomsPage = "/teacher/classrooms";
  static const String browseTeachersPage = "/teacher/browse_teachers";
  static const String studentExamsPage = "/student/exams";
  static const String studentExamDetailsPage = "/student/exams/details";
  static const String studentChannelRoute = "/student/channel/:classroomId";
  static String studentChannelPage(String classroomId) =>
      "/student/channel/$classroomId";
  static const String teacherChannelRoute = "/teacher/channel/:classroomId";
  static String teacherChannelPage(String classroomId) =>
      "/teacher/channel/$classroomId";
  static String teacherClassroomsPage(String teacherId) =>
      "/student/teachers/$teacherId/classrooms";
  static const String createClassroomPage = "/teacher/classrooms/create";
  static String classroomStudentsPage(String classroomId) =>
      "/teacher/classrooms/$classroomId/students";
  static const String teacherProfilePage = "/teacher/profile";
  static const String studentProfilePage = "/student/profile";
  static const String paymentWebViewPage = "/payment/pay";
  static const String paymentResultPage = "/payment/result";
  static const String materialsPage = "/teacher/materials/:classroomId";
  static const String studentClassroomsMaterialsPage =
      "/student/classrooms/materials";
  static const String studentClassroomMaterialsRoute =
      "/student/classrooms/:classroomId/materials";
  static String studentClassroomMaterialsPage(String classroomId) =>
      "/student/classrooms/$classroomId/materials";
  static const String studentEnrolledClassroomsPage =
      "/student/enrolled_classrooms";

  static const String sectionsPage = "/teacher/sections";
}

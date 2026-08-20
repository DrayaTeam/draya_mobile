import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/features/auth/presentation/signin/pages/signin_page.dart";
import "package:draya_mobile/features/auth/presentation/signup/pages/signup_page.dart";
import "package:draya_mobile/features/auth/presentation/signup_choice/pages/signup_choice_page.dart";
import "package:draya_mobile/features/auth/presentation/verification_code_page/pages/verification_code_page.dart";
import "package:draya_mobile/features/student/exams/presentation/pages/student_exam_details_screen.dart";
import "package:draya_mobile/features/student/exams/presentation/pages/student_exams_screen.dart";
import "package:draya_mobile/features/student/home/presentation/pages/student_home_screen.dart";
import "package:draya_mobile/features/student/profile/presentation/pages/student_profile_page.dart";
import "package:draya_mobile/features/student/student_channel/presentation/pages/student_channel_screen.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/presentation/pages/student_enrolled_classrooms_screen.dart";
import "package:draya_mobile/features/student/student_materials/presentation/pages/student_classrooms_materials_screen.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/pages/create_classroom_page.dart";
import "package:draya_mobile/features/student/teachers/presentation/pages/browse_teachers_screen.dart";
import "package:draya_mobile/features/student/teachers/presentation/pages/teacher_classrooms_page.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/pages/teacher_dashboard_screen.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/pages/exam_generation_step_1.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/pages/exam_generation_step_2.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/pages/exam_generation_step_3.dart";
import "package:draya_mobile/features/teacher/materials/presentation/pages/materials_page.dart";
import "package:draya_mobile/features/teacher/payments/data/models/payment_webview_model.dart";
import "package:draya_mobile/features/teacher/payments/presentation/pages/payment_web_view_page.dart";
import "package:draya_mobile/features/teacher/profile/presentation/pages/teacher_profile_page.dart";
import "package:draya_mobile/features/teacher/students_list/presentation/pages/students_list_screen.dart";
import "package:draya_mobile/features/teacher/subjects/presentation/pages/create_subject_page.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/pages/classrooms_page.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/pages/classroom_students_page.dart";
import "package:draya_mobile/features/student/teachers/data/models/teacher_model.dart";
import "package:draya_mobile/features/student/teachers/presentation/pages/payment_result_page.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/presentation/pages/teacher_channel_screen.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";


const authRoutes = {
  AppRoutes.signinPage,
  AppRoutes.signupPage,
  AppRoutes.verificationCodePage,
};

abstract final class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.signinPage,

    redirect: (context, state) async {
      await AppTokenHelper.isSignedIn();
      final isSignedIn = AppTokenHelper.isLoggedIn;
      final isGoingToAuthFlow = authRoutes.contains(state.matchedLocation);
      final goingToSignin = state.matchedLocation == AppRoutes.signinPage;

      if (isSignedIn && goingToSignin) {
        final role = await AppTokenHelper.getUserRole();
        return role == "Teacher"
            ? AppRoutes.teacherDashboardPage
            : AppRoutes.studentHomePage;
      }

      if (!isSignedIn && !isGoingToAuthFlow) {
        return AppRoutes.signinPage;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.signupChoice,
        builder: (context, state) {
          return const SignupChoicePage();
        },
      ),
      GoRoute(
        path: AppRoutes.signinPage,
        builder: (context, state) {
          return const SigninPage();
        },
      ),
      GoRoute(
        path: AppRoutes.signupPage,
        builder: (context, state) {
          return const SignupPage();
        },
      ),
      GoRoute(
        path: AppRoutes.verificationCodePage,
        builder: (context, state) {
          return const VerificationCodePage();
        },
      ),
      GoRoute(
        path: AppRoutes.teacherDashboardPage,
        builder: (context, state) {
          return TeacherDashboardScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.examGenerationPage1,
        builder: (context, state) {
          return const ExamGenerationStep1();
        },
      ),
      GoRoute(
        path: AppRoutes.examGenerationPage2,
        builder: (context, state) {
          return const ExamGenerationStep2();
        },
      ),
      GoRoute(
        path: AppRoutes.examGenerationPage3,
        builder: (context, state) {
          return const ExamGenerationStep3();
        },
      ),
      GoRoute(
        path: AppRoutes.studentsListPage,
        builder: (context, state) {
          return const StudentsListScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.studentHomePage,
        builder: (context, state) {
          return const StudentHomeScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.subjectsPage,
        builder: (context, state) {
          return const CreateSubjectPage();
        },
      ),
      GoRoute(
        path: AppRoutes.classroomsPage,
        builder: (context, state) {
          return const ClassroomsPage();
        },
      ),
      GoRoute(
        path: AppRoutes.createClassroomPage,
        builder: (context, state) {
          return const CreateClassroomPage();
        },
      ),
      GoRoute(
        path: AppRoutes.browseTeachersPage,
        builder: (context, state) {
          return const BrowseTeachersScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.studentExamsPage,
        builder: (context, state) {
          return const StudentExamsScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.teacherClassroomsPage(":teacherId"),
        builder: (context, state) {
          final teacherId = state.pathParameters["teacherId"] ?? "";
          final teacher = state.extra as TeacherModel?;
          return TeacherClassroomsPage(
            teacherId: teacherId,
            teacher: teacher,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.studentExamDetailsPage,
        builder: (context, state) {
          String examId = "";
          String? classroomName;
          if (state.extra is Map) {
            final map = state.extra as Map;
            examId = map["examId"]?.toString() ?? "";
            classroomName = map["classroomName"]?.toString();
          } else if (state.extra is String) {
            examId = state.extra as String;
          }
          return StudentExamDetailsScreen(
            examId: examId,
            classroomName: classroomName,
          );
        },
      ),
      GoRoute(
        path: "/teacher/classrooms/:classroomId/students",
        builder: (context, state) {
          return ClassroomStudentsPage(
            classroom: state.extra! as ClassroomModel,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.teacherProfilePage,
        builder: (context, state) {
          return const TeacherProfilePage();
        },
      ),
      GoRoute(
        path: AppRoutes.studentProfilePage,
        builder: (context, state) {
          return const StudentProfilePage();
        },
      ),
      GoRoute(
        path: AppRoutes.studentChannelRoute,
        builder: (context, state) {
          return StudentChannelScreen(
            classroomId: state.pathParameters["classroomId"]!,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.teacherChannelRoute,
        builder: (context, state) {
          return TeacherChannelScreen(
            classroomId: state.pathParameters["classroomId"]!,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.paymentWebViewPage,
        builder: (context, state) {
          final model = state.extra is PaymentWebviewModel
              ? state.extra as PaymentWebviewModel
              : const PaymentWebviewModel(
                  appBarTitle: "invalid",
                  url: "invalid",
                );

          return PaymentWebViewPage(model);
        },
      ),
      GoRoute(
        path: AppRoutes.paymentResultPage,
        builder: (context, state) {
          final transactionId = state.extra as String? ??
              state.uri.queryParameters["transactionId"] ??
              "";
          return PaymentResultPage(transactionId: transactionId);
        },
      ),
      GoRoute(
        path: AppRoutes.materialsPage,
        builder: (context, state) {
          return MaterialsPage(
            state.extra as ClassroomModel,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.studentClassroomsMaterialsPage,
        builder: (context, state) {
          return const StudentClassroomsMaterialsScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.studentClassroomMaterialsRoute,
        builder: (context, state) {
          return StudentClassroomsMaterialsScreen(
            classroomId: state.pathParameters["classroomId"],
            classroomName: state.extra as String?,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.studentEnrolledClassroomsPage,
        builder: (context, state) {
          return const StudentEnrolledClassroomsScreen();
        },
      ),
    ],
  );
}

import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/features/auth/presentation/signin/pages/signin_page.dart";
import "package:draya_mobile/features/auth/presentation/signup/pages/signup_page.dart";
import "package:draya_mobile/features/auth/presentation/signup_choice/pages/signup_choice_page.dart";
import "package:draya_mobile/features/auth/presentation/verification_code_page/pages/verification_code_page.dart";
import "package:draya_mobile/features/student/exams/presentation/pages/student_exam_details_screen.dart";
import "package:draya_mobile/features/student/exams/presentation/pages/student_exams_screen.dart";
import "package:draya_mobile/features/student/exams_history/presentation/pages/exams_history_screen.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/pages/attempt_review_screen.dart";
import "package:draya_mobile/features/student/home/presentation/pages/student_home_screen.dart";
import "package:draya_mobile/features/student/profile/presentation/pages/student_profile_page.dart";
import "package:draya_mobile/features/student/student_weak_topics/presentation/pages/student_weak_topics.dart";
import "package:draya_mobile/features/student/student_channel/presentation/pages/student_channel_screen.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/presentation/pages/student_enrolled_classrooms_screen.dart";
import "package:draya_mobile/features/student/student_feedback/presentation/pages/student_feedback_screen.dart";
import "package:draya_mobile/features/teacher/reports/presentation/pages/reports_page.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/pages/classroom_exam_grades_screen.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/pages/exam_attempts_screen.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/pages/students_grades_screen.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/presentation/pages/classroom_feedback_screen.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/presentation/pages/teacher_feedback_screen.dart";
import "package:draya_mobile/features/student/student_materials/presentation/pages/student_classrooms_materials_screen.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/pages/create_classroom_page.dart";
import "package:draya_mobile/features/student/teachers/presentation/pages/browse_teachers_screen.dart";
import "package:draya_mobile/features/student/teachers/presentation/pages/teacher_classrooms_page.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/pages/teacher_dashboard_screen.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/pages/exam_generation_step_1.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/pages/exam_generation_step_2.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/pages/exam_generation_step_3.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";
import "package:draya_mobile/features/teacher/exams/presentation/pages/teacher_exam_questions_screen.dart";
import "package:draya_mobile/features/teacher/exams/presentation/pages/teacher_exams_screen.dart";
import "package:draya_mobile/features/teacher/materials/presentation/pages/materials_page.dart";
import "package:draya_mobile/features/teacher/payments/data/models/payment_webview_model.dart";
import "package:draya_mobile/features/teacher/payments/presentation/pages/payment_web_view_page.dart";
import "package:draya_mobile/features/teacher/profile/presentation/pages/teacher_profile_page.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";
import "package:draya_mobile/features/teacher/sections/presentation/pages/sections_page.dart";
import "package:draya_mobile/features/teacher/students_list/presentation/pages/students_list_screen.dart";
import "package:draya_mobile/features/teacher/subjects/presentation/pages/create_subject_page.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/pages/classrooms_page.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/pages/classroom_students_page.dart";
import "package:draya_mobile/features/student/teachers/data/models/teacher_model.dart";
import "package:draya_mobile/features/student/teachers/presentation/pages/payment_result_page.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/presentation/pages/teacher_channel_screen.dart";
import "package:draya_mobile/features/notifications/presentation/pages/notifications_page.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

abstract final class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.signinPage,

    redirect: (context, state) async {
      await AppTokenHelper.isSignedIn();

      final isSignedIn = AppTokenHelper.isLoggedIn;

      final isGoingToSignin = state.matchedLocation == AppRoutes.signinPage;

      final location = state.matchedLocation;

      final isAuthRoute =
          location == AppRoutes.signinPage ||
          location == AppRoutes.signupPage ||
          location.startsWith("/verification_code/");

      if (isSignedIn && isGoingToSignin) {
        final role = await AppTokenHelper.getUserRole();

        return role == "Teacher"
            ? AppRoutes.teacherDashboardPage
            : AppRoutes.studentHomePage;
      }

      if (!isSignedIn && !isAuthRoute) {
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
          final email = state.uri.queryParameters["email"] as String;

          return VerificationCodePage(
            email: email,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.teacherDashboardPage,
        builder: (context, state) {
          return const TeacherDashboardScreen();
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
          final map = state.extra is Map
              ? state.extra as Map
              : <String, dynamic>{};
          final classroomId = map["classroomId"]?.toString() ?? "";
          final classroomName = map["classroomName"]?.toString();
          final subjectName = map["subjectName"]?.toString();
          final sectionId = map["sectionId"]?.toString() ?? "";
          final sectionTitle = map["sectionTitle"]?.toString();
          final topic = map["topic"]?.toString() ?? "";
          final difficultyLevel = map["difficultyLevel"]?.toString() ?? "easy";
          final rawRequirements = map["questionRequirements"];
          final questionRequirements = rawRequirements is List
              ? rawRequirements.whereType<QuestionRequirementModel>().toList()
              : <QuestionRequirementModel>[];
          final teacherInstructions =
              map["teacherInstructions"]?.toString() ?? "";

          return ExamGenerationStep2(
            classroomId: classroomId,
            classroomName: classroomName,
            subjectName: subjectName,
            sectionId: sectionId,
            sectionTitle: sectionTitle,
            topic: topic,
            difficultyLevel: difficultyLevel,
            questionRequirements: questionRequirements,
            teacherInstructions: teacherInstructions,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.examGenerationPage3,
        builder: (context, state) {
          final map = state.extra is Map
              ? state.extra as Map
              : <String, dynamic>{};
          final generationId = map["generationId"]?.toString();
          final examId = map["examId"]?.toString();
          final topic = map["topic"]?.toString() ?? "";
          final classroomId = map["classroomId"]?.toString() ?? "";
          final classroomName = map["classroomName"]?.toString();
          final subjectName = map["subjectName"]?.toString();
          final sectionId = map["sectionId"]?.toString() ?? "";
          final sectionTitle = map["sectionTitle"]?.toString();
          final difficultyLevel = map["difficultyLevel"]?.toString() ?? "easy";
          final rawRequirements = map["questionRequirements"];
          final questionRequirements = rawRequirements is List
              ? rawRequirements.whereType<QuestionRequirementModel>().toList()
              : <QuestionRequirementModel>[];
          final durationMinutes = map["durationMinutes"] is int
              ? map["durationMinutes"] as int
              : int.tryParse(map["durationMinutes"]?.toString() ?? "");
          final allowedAttempts = map["allowedAttempts"] is int
              ? map["allowedAttempts"] as int
              : int.tryParse(map["allowedAttempts"]?.toString() ?? "");
          final startDate = map["startDate"]?.toString();
          final endDate = map["endDate"]?.toString();

          return ExamGenerationStep3(
            generationId: generationId,
            examId: examId,
            topic: topic,
            classroomId: classroomId,
            classroomName: classroomName,
            subjectName: subjectName,
            sectionId: sectionId,
            sectionTitle: sectionTitle,
            difficultyLevel: difficultyLevel,
            questionRequirements: questionRequirements,
            durationMinutes: durationMinutes,
            allowedAttempts: allowedAttempts,
            startDate: startDate,
            endDate: endDate,
          );
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
        path: AppRoutes.teacherExamsPage,
        builder: (context, state) {
          return const TeacherExamsScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.teacherExamQuestionsPage,
        builder: (context, state) {
          final map = state.extra is Map
              ? state.extra as Map
              : <String, dynamic>{};
          return TeacherExamQuestionsScreen(
            examId: map["examId"]?.toString() ?? "",
            classroomName: map["classroomName"]?.toString(),
            sectionTitle: map["sectionTitle"]?.toString(),
          );
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
        path: AppRoutes.studentExamsHistoryPage,
        builder: (context, state) {
          return const ExamsHistoryScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.teacherAttemptReviewPage(":attemptId"),
        builder: (context, state) {
          final map = state.extra is Map
              ? state.extra as Map
              : <String, dynamic>{};
          return AttemptReviewScreen(
            attemptId: state.pathParameters["attemptId"] ?? "",
            examTitle: map["examTitle"]?.toString(),
            studentName: map["studentName"]?.toString(),
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
        path: AppRoutes.studentChannelMainPage,
        builder: (context, state) {
          return const StudentChannelScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.studentChannelRoute,
        builder: (context, state) {
          return StudentChannelScreen(
            initialClassroomId: state.pathParameters["classroomId"],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.teacherChannelMainPage,
        builder: (context, state) {
          return const TeacherChannelScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.teacherChannelRoute,
        builder: (context, state) {
          return TeacherChannelScreen(
            initialClassroomId: state.pathParameters["classroomId"],
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
          final transactionId =
              state.extra as String? ??
              state.uri.queryParameters["transactionId"] ??
              "";
          return PaymentResultPage(transactionId: transactionId);
        },
      ),
      GoRoute(
        path: AppRoutes.materialsPage,
        builder: (context, state) {
          return MaterialsPage(
            state.pathParameters["classroomId"] as String,
            state.extra as SectionModel,
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
      GoRoute(
        path: AppRoutes.studentWeakTopicsPage,
        builder: (context, state) {
          String? initialTopic;
          String? studentId;
          if (state.extra is Map) {
            final map = state.extra as Map;
            initialTopic = map["initialTopic"]?.toString();
            studentId = map["studentId"]?.toString();
          } else if (state.extra is String) {
            initialTopic = state.extra as String;
          }
          return StudentWeakTopics(
            initialTopic: initialTopic,
            studentId: studentId,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.sectionsPage,
        builder: (context, state) {
          final ClassroomModel classroomModel = state.extra as ClassroomModel;

          return SectionsPage(classroomModel);
        },
      ),
      GoRoute(
        path: AppRoutes.studentFeedbackPage,
        builder: (context, state) {
          return const StudentFeedbackScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.teacherFeedbackPage,
        builder: (context, state) {
          return const TeacherFeedbackScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.notificationsPage,
        builder: (context, state) {
          return const NotificationsPage();
        },
      ),
      GoRoute(
        path: AppRoutes.teacherClassroomFeedbackRoute,
        builder: (context, state) {
          return ClassroomFeedbackScreen(
            classroomId: state.pathParameters["classroomId"] ?? "",
            classroomName: state.extra as String?,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.reportsPage,
        builder: (context, state) {
          return const ReportsPage();
        },
      ),
      GoRoute(
        path: AppRoutes.studentsGradesPage,
        builder: (context, state) {
          return const StudentsGradesScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.classroomExamGradesPage(":classroomId"),
        builder: (context, state) {
          return ClassroomExamGradesScreen(
            classroomId: state.pathParameters["classroomId"] ?? "",
            classroomName: state.extra as String?,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.examAttemptsPage(":examId"),
        builder: (context, state) {
          return ExamAttemptsScreen(
            examId: state.pathParameters["examId"] ?? "",
            examTitle: state.extra as String?,
          );
        },
      ),
    ],
  );
}

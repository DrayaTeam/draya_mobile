import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/features/auth/presentation/signin/pages/signin_page.dart';
import 'package:draya_mobile/features/auth/presentation/signup/pages/signup_page.dart';
import 'package:draya_mobile/features/auth/presentation/signup_choice/pages/signup_choice_page.dart';
import 'package:draya_mobile/features/auth/presentation/verification_code_page/pages/verification_code_page.dart';
import 'package:draya_mobile/features/teacher/dashboard/presentation/pages/teacher_dashboard_screen.dart';
import 'package:draya_mobile/features/teacher/exam_generation/presentation/pages/exam_generation_step_1.dart';
import 'package:draya_mobile/features/teacher/exam_generation/presentation/pages/exam_generation_step_2.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.signinPage,

    // redirect: (context, state) async {
    //   final bool isSignedIn = await AppTokenHelper.isSignedIn();

    //   final goingToSignin = state.matchedLocation == AppRoutes.signinPage;

    //   if (!isSignedIn && !goingToSignin) {
    //     return AppRoutes.homePage;
    //   }

    //   if (isSignedIn && goingToSignin) {
    //     return AppRoutes.mainPage;
    //   }

    //   return null;
    // },
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
    ],
  );
}

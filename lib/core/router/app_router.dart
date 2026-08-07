import 'package:draya_mobile/core/helpers/app_token_helper.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/features/auth/presentation/signin/pages/signin_page.dart';
import 'package:draya_mobile/features/auth/presentation/signup/pages/signup_page.dart';
import 'package:draya_mobile/features/auth/presentation/signup_choice/pages/signup_choice_page.dart';
import 'package:draya_mobile/features/auth/presentation/verification_code_page/pages/verification_code_page.dart';
import 'package:draya_mobile/features/student/home/presentation/pages/student_home_screen.dart';
import 'package:draya_mobile/features/teacher/dashboard/presentation/pages/teacher_dashboard_screen.dart';
import 'package:go_router/go_router.dart';

const authRoutes = {
  AppRoutes.signinPage,
  AppRoutes.signupPage,
  AppRoutes.verificationCodePage,
};

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.signinPage,

    redirect: (context, state) async {
      await AppTokenHelper.isSignedIn();
      final isSignedIn = AppTokenHelper.isLoggedIn;
      final isGoingToAuthFlow = authRoutes.contains(state.matchedLocation);
      final goingToSignin = state.matchedLocation == AppRoutes.signinPage;

      if (isSignedIn && goingToSignin) {
        final role = await AppTokenHelper.getUserRole();
        return role == 'Teacher'
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
          return const TeacherDashboardScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.studentHomePage,
        builder: (context, state) {
          return const StudentHomeScreen();
        },
      ),
    ],
  );
}

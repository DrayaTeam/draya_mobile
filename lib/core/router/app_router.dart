import 'package:draya_mobile/core/enums/user_role.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/features/auth/presentation/signin/pages/signin_page.dart';
import 'package:draya_mobile/features/auth/presentation/student_signup/pages/student_signup_page.dart';
import 'package:draya_mobile/features/auth/presentation/teacher_signup/pages/teacher_signup_page.dart';
import 'package:draya_mobile/features/home/presentation/home_screen/pages/home_screen_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.homePage,

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
        path: AppRoutes.homePage,
        builder: (context, state) {
          return const HomeScreenPage();
        },
      ),
      GoRoute(
        path: AppRoutes.signinPage,
        builder: (context, state) {
          final String userRole =
              state.pathParameters[AppRoutes.userRoleParameter] as String;
          return SigninPage(userRole: UserRole.fromName(name: userRole));
        },
      ),
      GoRoute(
        path: AppRoutes.studentSignupPage,
        builder: (context, state) {
          return const StudentSignupPage();
        },
      ),
      GoRoute(
        path: AppRoutes.teacherSignupPage,
        builder: (context, state) {
          return const TeacherSignupPage();
        },
      ),
    ],
  );
}

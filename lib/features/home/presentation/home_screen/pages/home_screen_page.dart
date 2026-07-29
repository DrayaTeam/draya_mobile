import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/enums/user_role.dart';
import 'package:draya_mobile/features/home/presentation/home_screen/cubit/home_screen_cubit.dart';
import 'package:draya_mobile/features/home/presentation/home_screen/cubit/home_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenPage extends StatelessWidget {
  const HomeScreenPage({super.key});

  void _handleNavigation({
    required BuildContext context,
    required UserRole userRole,
  }) {
    AppNavigator.push(
      context: context,
      path: AppRoutes.signinPage,
      pathParameters: {AppRoutes.userRoleParameter: userRole.name},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenCubit, HomeScreenState>(
      listener: (context, state) {},
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 40,
                    foregroundColor: AppColors.surface,
                    child: Text(
                      "Draya",
                      style: TextStyle(fontSize: AppSizes.s20),
                    ),
                  ),
                  const SizedBox(height: AppSizes.s32),
                  const Text(
                    "Sign in/up as",
                    style: TextStyle(fontSize: AppSizes.s20),
                  ),
                  const SizedBox(height: AppSizes.s12),
                  ...UserRole.values.map((user) {
                    return ElevatedButton(
                      onPressed: () {
                        _handleNavigation(context: context, userRole: user);
                      },
                      child: Text(user.displayName),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import "package:draya_mobile/core/helpers/app_extensions.dart";
import "package:draya_mobile/core/localization/locale_cubit.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/enums/user_role.dart";
import "package:draya_mobile/core/widgets/app_logo_and_name.dart";
import "package:draya_mobile/features/auth/presentation/signup_choice/cubit/signup_choice_cubit.dart";
import "package:draya_mobile/features/auth/presentation/signup_choice/cubit/signup_choice_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SignupChoicePage extends StatelessWidget {
  const SignupChoicePage({super.key});

  void _handleNavigation({
    required BuildContext context,
    required UserRole userRole,
  }) {
    // AppNavigator.push(
    //   context: context,
    //   path: switch (userRole) {
    //     UserRole.student => AppRoutes.studentSignupPage,
    //     UserRole.teacher => AppRoutes.teacherSignupPage,
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupChoiceCubit, SignupChoiceState>(
      listener: (context, state) {},
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogoAndName(),
                  const SizedBox(height: AppSizes.s64),
                  const Text(
                    "Sign up as",
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<LocaleCubit>().toggleLanguage();
          },
          label: Text(context.l10n.oppositeLanguage),
        ),
      ),
    );
  }
}

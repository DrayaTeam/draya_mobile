import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/enums/user_role.dart';
import 'package:draya_mobile/features/auth/presentation/signin/pages/signin_page.dart';
import 'package:draya_mobile/features/home/presentation/home_screen/cubit/home_screen_cubit.dart';
import 'package:draya_mobile/features/home/presentation/home_screen/cubit/home_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenPage extends StatelessWidget {
  const HomeScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenCubit, HomeScreenState>(
      listener: (context, state) {
        if (state is NavigateToStudentSignin) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SigninPage(
                userRole: UserRole.student,
              ),
            ),
          );
        } else if (state is NavigateToTeacherSignin) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const SigninPage(userRole: UserRole.teacher),
            ),
          );
        }
      },
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
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeScreenCubit>().navigateToStudentSignin();
                    },
                    child: const Text("Student"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeScreenCubit>().navigateToTeacherSignin();
                    },
                    child: const Text("Teacher"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

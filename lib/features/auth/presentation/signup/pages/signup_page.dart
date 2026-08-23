import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/widgets/app_logo_and_name.dart";
import "package:draya_mobile/features/auth/presentation/student_signup/pages/student_signup_tab.dart";
import "package:draya_mobile/features/auth/presentation/teacher_signup/pages/teacher_signup_tab.dart";
import "package:flutter/material.dart";

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  int _selectedIndex = 0;

  static const List<(String, IconData)> _roles = [
    ("طالب", Icons.person_outline),
    ("معلم", Icons.school_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: AppSizes.s24, right: AppSizes.s24, top: AppSizes.s24),
              child: Column(
                children: [
                  const AppLogoAndName(),
                  const SizedBox(height: AppSizes.s24),
                  _buildRoleToggle(),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: const [
                  StudentSignupTab(),
                  TeacherSignupTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleToggle() {
    return Row(
      spacing: AppSizes.s12,
      children: List.generate(_roles.length, (index) {
        final isActive = index == _selectedIndex;
        final (label, icon) = _roles[index];

        return Expanded(
          child: Semantics(
            label: "التسجيل كـ $label",
            button: true,
            selected: isActive,
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: AppSizes.s8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.s36),
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.borderStrong,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: AppSizes.s8,
                  children: [
                    Icon(
                      icon,
                      size: AppSizes.s20,
                      color:
                          isActive ? AppColors.primary50 : AppColors.textSecondary,
                    ),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color:
                                isActive ? Colors.white : AppColors.textSecondary,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                          ),
                      child: Text(label),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

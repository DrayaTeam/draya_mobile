import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/auth/presentation/student_signup/pages/student_signup_tab.dart";
import "package:draya_mobile/features/auth/presentation/teacher_signup/pages/teacher_signup_tab.dart";
import "package:flutter/material.dart";

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "تسجيل الدخول",
          bottom: TabBar(
            tabs: [
              Tab(text: "طالب"),
              Tab(text: "معلم"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StudentSignupTab(),
            TeacherSignupTab(),
          ],
        ),
      ),
    );
  }
}

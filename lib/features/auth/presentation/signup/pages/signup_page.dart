import 'package:draya_mobile/features/auth/presentation/student_signup/pages/student_signup_tab.dart';
import 'package:draya_mobile/features/auth/presentation/teacher_signup/pages/teacher_signup_tab.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Student"),
              Tab(text: "Teacher"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StudentSignupTab(),
            TeacherSignupTab(),
          ],
        ),
      ),
    );
  }
}

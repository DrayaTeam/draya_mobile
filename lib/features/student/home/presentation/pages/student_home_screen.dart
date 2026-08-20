import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/student/home/presentation/widgets/student_home_body.dart";
import "package:flutter/material.dart";

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "الرئيسية"),
      drawer: AppDrawer(
        drawerItemsList: getStudentDrawerItemsList(),
      ),
      body: const StudentHomeBody(),
    );
  }
}

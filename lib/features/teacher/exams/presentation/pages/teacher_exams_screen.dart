import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/teacher/exams/presentation/widgets/teacher_exams_body.dart";
import "package:flutter/material.dart";

class TeacherExamsScreen extends StatelessWidget {
  const TeacherExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "الامتحانات"),
      drawer: AppDrawer(
        drawerItemsList: getTeacherDrawerItemsList(),
      ),
      body: const TeacherExamsBody(),
    );
  }
}

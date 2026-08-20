import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/student/teachers/presentation/widgets/browse_teachers_body.dart";
import "package:flutter/material.dart";

class BrowseTeachersScreen extends StatelessWidget {
  const BrowseTeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "قايمة المعلمين"),
      drawer: AppDrawer(
        drawerItemsList: getStudentDrawerItemsList(),
      ),
      body: const BrowseTeachersBody(),
    );
  }
}

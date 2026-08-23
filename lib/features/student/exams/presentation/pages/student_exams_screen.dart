import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/student/exams/presentation/widgets/student_exams_body.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/presentation/cubit/student_enrolled_classrooms_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentExamsScreen extends StatelessWidget {
  const StudentExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentEnrolledClassroomsCubit>(
      create: (_) => getIt<StudentEnrolledClassroomsCubit>(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: "الامتحانات",
          actions: [
            IconButton(
              tooltip: "سجل المحاولات",
              onPressed: () {
                AppNavigator.push(
                  context: context,
                  path: AppRoutes.studentExamsHistoryPage,
                );
              },
              icon: const Icon(Icons.history_rounded),
            ),
          ],
        ),
        drawer: AppDrawer(
          drawerItemsList: getStudentDrawerItemsList(),
        ),
        body: const StudentExamsBody(),
      ),
    );
  }
}

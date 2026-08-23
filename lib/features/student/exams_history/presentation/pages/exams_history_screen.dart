import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/student/exams_history/presentation/cubit/exams_history_cubit.dart";
import "package:draya_mobile/features/student/exams_history/presentation/widgets/exams_history_body.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ExamsHistoryScreen extends StatelessWidget {
  const ExamsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExamsHistoryCubit>(
      create: (_) => getIt<ExamsHistoryCubit>(),
      child: Scaffold(
        appBar: const CustomAppBar(title: "سجل المحاولات"),
        drawer: AppDrawer(drawerItemsList: getStudentDrawerItemsList()),
        body: const SafeArea(child: ExamsHistoryBody()),
      ),
    );
  }
}

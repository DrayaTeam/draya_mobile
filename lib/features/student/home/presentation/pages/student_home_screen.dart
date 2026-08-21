import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/student/home/presentation/cubit/student_home_cubit.dart";
import "package:draya_mobile/features/student/home/presentation/cubit/student_home_state.dart";
import "package:draya_mobile/features/student/home/presentation/widgets/student_home_body.dart";
import "package:draya_mobile/features/student/profile/presentation/cubit/student_profile_cubit.dart";
import "package:draya_mobile/features/student/profile/presentation/cubit/student_profile_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StudentProfileCubit>().getStudentProfile();
    context.read<StudentHomeCubit>().getStudentDashboard();
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<StudentProfileCubit>().getStudentProfile(),
      context.read<StudentHomeCubit>().getStudentDashboard(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "الرئيسية"),
      drawer: AppDrawer(
        drawerItemsList: getStudentDrawerItemsList(),
      ),
      body: BlocListener<StudentHomeCubit, StudentHomeState>(
        listener: (context, state) {
          if (state.status == CubitStatus.error && state.apiErrorModel != null) {
            AppDialogHelper.display(
              context,
              AppErrorDialog(
                apiErrorModel: state.apiErrorModel!,
                onRetry: () {
                  context.read<StudentHomeCubit>().getStudentDashboard();
                },
              ),
            );
          }
        },
        child: BlocBuilder<StudentProfileCubit, StudentProfileState>(
          builder: (context, profileState) {
            final fullName = profileState.studentProfile?.fullName;
            final studentFirstName = fullName != null && fullName.trim().isNotEmpty
                ? fullName.trim().split(" ").first
                : null;

            return BlocBuilder<StudentHomeCubit, StudentHomeState>(
              builder: (context, homeState) {
                return RefreshIndicator(
                  color: AppColors.primary700,
                  backgroundColor: Colors.white,
                  onRefresh: _refresh,
                  child: StudentHomeBody(
                    studentDashboard: homeState.studentDashboard,
                    studentName: studentFirstName,
                    isLoading: homeState.status == CubitStatus.loading,
                    onRetry: () {
                      context.read<StudentHomeCubit>().getStudentDashboard();
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

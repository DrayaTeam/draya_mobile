import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/helpers/app_extensions.dart";
import "package:draya_mobile/core/helpers/app_loading.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_card_container_empty.dart";
import "package:draya_mobile/core/widgets/app_card_container_info.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/app_list_tile_info.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/cubit/teacher_dashboard_cubit.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/cubit/teacher_dashboard_state.dart";
import "package:draya_mobile/features/teacher/profile/presentation/cubit/teacher_profile_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    context.read<TeacherProfileCubit>().getTeacherProfile();
    context.read<TeacherDashboardCubit>().getTeacherDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeacherDashboardCubit, TeacherDashboardState>(
      listener: (BuildContext context, TeacherDashboardState state) {
        switch (state.status) {
          case CubitStatus.loading:
            AppLoading.show();
            break;
          case CubitStatus.error:
            AppLoading.hide();

            AppDialogHelper.display(
              context,
              AppErrorDialog(apiErrorModel: state.apiErrorModel!),
            );
            break;
          default:
            AppLoading.hide();
            break;
        }
      },
      child: BlocBuilder<TeacherDashboardCubit, TeacherDashboardState>(
        builder: (BuildContext context, TeacherDashboardState state) {
          if (state.status != CubitStatus.success) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final teacher = state.teacherDashboardModel!;

          return Scaffold(
            appBar: const CustomAppBar(title: "لوحة التحكم"),
            drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(DateFormat.yMMMMEEEEd("ar").format(currentDate)),
                    Text(
                      context
                              .watch<TeacherProfileCubit>()
                              .state
                              .teacher
                              ?.fullName ??
                          "",
                      style: context.textTheme.displaySmall,
                    ),
                    const Text("اليك ملخص نشاط اكاديميتك اليوم"),
                    const SizedBox(height: AppSizes.s8),
                    const Divider(),
                    const SizedBox(height: AppSizes.s8),
                    AppCardContainerInfo(
                      icon: Icons.people_outline,
                      title: teacher.activeStudents.toString(),
                      subtitle: "طلاب نشطون",
                    ),
                    const SizedBox(height: AppSizes.s20),
                    AppCardContainerInfo(
                      icon: Icons.calendar_month_outlined,
                      title: teacher.examsAwaitingReview.toString(),
                      subtitle: "امتحانات بانتظار مراجعة",
                    ),
                    const SizedBox(height: AppSizes.s20),
                    AppCardContainerInfo(
                      icon: Icons.chat_bubble_outline,
                      title: teacher.newMessagesCount.toString(),
                      subtitle: "رسائل جديدة",
                    ),
                    const SizedBox(height: AppSizes.s20),
                    const Divider(),
                    const SizedBox(height: AppSizes.s20),
                    AppCardContainerEmpty(
                      children: [
                        AppListTileInfo(
                          title: "انشاء امتحان",
                          icon: Icons.create_outlined,
                          onTap: () {},
                        ),
                        const SizedBox(height: AppSizes.s20),
                        AppListTileInfo(
                          title: "متابعة الطلبة",
                          icon: Icons.people_outline,
                          onTap: () {},
                        ),
                        const SizedBox(height: AppSizes.s20),
                        AppListTileInfo(
                          title: "التقارير",
                          icon: Icons.edit_document,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.s20),
                    AppCardContainerEmpty(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "طلاب يحتاجون متابعة",
                                  style: context.textTheme.labelLarge,
                                ),
                                const Text("اداء دون 55% فى اخر امتحان"),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              label: const Text("الكل"),
                              icon: const Icon(
                                Icons.keyboard_arrow_left_rounded,
                              ),
                              iconAlignment: IconAlignment.end,
                            ),
                          ],
                        ),
                        const Divider(),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("الطالب"),
                            Text("الدرجة"),
                          ],
                        ),
                        const SizedBox(height: AppSizes.s12),

                        ...teacher.needsAttentionList.map(
                          (student) {
                            return AppCardContainerEmpty(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      student.studentName,
                                      style: context.textTheme.headlineMedium,
                                    ),

                                    Text(
                                      "${student.overallAverage.toInt()}%",
                                      style: context.textTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

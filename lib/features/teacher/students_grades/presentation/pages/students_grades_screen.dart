import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/cubit/grades_classrooms_cubit.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/cubit/grades_classrooms_state.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/widgets/classroom_grade_card.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/widgets/exam_grade_card.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/widgets/grades_empty_state.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/widgets/grades_hero_header.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class StudentsGradesScreen extends StatefulWidget {
  const StudentsGradesScreen({super.key});

  @override
  State<StudentsGradesScreen> createState() => _StudentsGradesScreenState();
}

class _StudentsGradesScreenState extends State<StudentsGradesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GradesClassroomsCubit>().getClassrooms();
  }

  void _onClassroomTap(String classroomId, String classroomName) {
    context.push(
      AppRoutes.classroomExamGradesPage(classroomId),
      extra: classroomName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "درجات الطلاب"),
      drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
      body: SafeArea(
        child: BlocConsumer<GradesClassroomsCubit, GradesClassroomsState>(
          listenWhen: (previous, current) =>
              current.status == CubitStatus.error &&
              current.apiErrorModel != null,
          listener: (context, state) {
            showDialog(
              context: context,
              builder: (_) => AppErrorDialog(
                apiErrorModel: state.apiErrorModel!,
                onRetry:
                    () => context
                        .read<GradesClassroomsCubit>()
                        .getClassrooms(),
              ),
            );
          },
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh:
                  () => context.read<GradesClassroomsCubit>().getClassrooms(),
              child: switch (state.status) {
                CubitStatus.loading => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                CubitStatus.error ||
                CubitStatus.initial => const GradesEmptyState(
                  icon: Icons.class_rounded,
                  title: "لا توجد فصول دراسية",
                  subtitle: "لم يتم العثور على أي فصول دراسية خاصة بك",
                ),
                CubitStatus.success when state.classrooms.isEmpty =>
                  const GradesEmptyState(
                    icon: Icons.class_rounded,
                    title: "لا توجد فصول دراسية",
                    subtitle:
                        "أنشئ فصلاً دراسياً أولاً لتتمكن من عرض درجات طلابه",
                  ),
                CubitStatus.success => ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.s16),
                  itemCount: state.classrooms.length + 1,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GradesHeroHeader(
                            title: "درجات الطلاب",
                            subtitle: "اختر فصلاً لعرض امتحاناته ونتائج طلابه",
                            icon: Icons.grading_rounded,
                          ),
                          SizedBox(height: AppSizes.s16),
                        ],
                      );
                    }
                    final classroom = state.classrooms[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.s12),
                      child: FadeInUp(
                        delay: index * 60,
                        child: ClassroomGradeCard(
                          name: classroom.name,
                          subjectName: classroom.subjectName,
                          studentCount: classroom.studentCount,
                          accent: GradesAccentPalette.forIndex(index - 1),
                          onTap:
                              () => _onClassroomTap(
                                classroom.classroomId,
                                classroom.name,
                              ),
                        ),
                      ),
                    );
                  },
                ),
              },
            );
          },
        ),
      ),
    );
  }
}

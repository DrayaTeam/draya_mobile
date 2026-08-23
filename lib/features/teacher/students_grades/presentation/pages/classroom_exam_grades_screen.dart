import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/cubit/grades_exams_cubit.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/cubit/grades_exams_state.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/widgets/exam_grade_card.dart";import "package:draya_mobile/features/teacher/students_grades/presentation/widgets/grades_empty_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class ClassroomExamGradesScreen extends StatefulWidget {
  final String classroomId;
  final String? classroomName;

  const ClassroomExamGradesScreen({
    super.key,
    required this.classroomId,
    this.classroomName,
  });

  @override
  State<ClassroomExamGradesScreen> createState() =>
      _ClassroomExamGradesScreenState();
}

class _ClassroomExamGradesScreenState extends State<ClassroomExamGradesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GradesExamsCubit>().getExams(widget.classroomId);
  }

  void _onExamTap(ExamGradesItem item) {
    context.push(
      AppRoutes.examAttemptsPage(item.exam.id),
      extra: item.exam.topic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: widget.classroomName ?? "امتحانات الفصل",
      ),
      body: SafeArea(
        child: BlocBuilder<GradesExamsCubit, GradesExamsState>(
          builder: (context, state) {
            return switch (state.status) {
              CubitStatus.loading => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              CubitStatus.error ||
              CubitStatus.initial => const GradesEmptyState(
                icon: Icons.assignment_outlined,
                title: "حدث خطأ",
                subtitle: "تعذر تحميل الامتحانات، حاول مرة أخرى",
              ),
              CubitStatus.success when state.exams.isEmpty =>
                const GradesEmptyState(
                  icon: Icons.assignment_outlined,
                  title: "لا توجد امتحانات",
                  subtitle: "لم يتم نشر أي امتحانات في هذا الفصل حتى الآن",
                ),
              CubitStatus.success => _ExamsList(
                exams: state.exams,
                onExamTap: _onExamTap,
              ),
            };
          },
        ),
      ),
    );
  }
}

class _ExamsList extends StatelessWidget {
  final List<ExamGradesItem> exams;
  final void Function(ExamGradesItem) onExamTap;

  const _ExamsList({required this.exams, required this.onExamTap});

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<ExamGradesItem>>{};
    for (final item in exams) {
      groups.putIfAbsent(item.sectionTitle, () => []).add(item);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.s16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final sectionTitle = groups.keys.elementAt(index);
        final sectionExams = groups[sectionTitle]!;
        final accent = GradesAccentPalette.forIndex(index);

        return FadeInUp(
          delay: index * 80,
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.s20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: AppSizes.s4,
                      height: AppSizes.s16,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [accent, accent.withValues(alpha: 0.4)],
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.s4),
                      ),
                    ),
                    const SizedBox(width: AppSizes.s8),
                    Expanded(
                      child: Text(
                        sectionTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.h5.copyWith(fontSize: 15),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s10,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(AppSizes.s6),
                      ),
                      child: Text(
                        "${sectionExams.length} امتحان",
                        style: AppTextStyles.label.copyWith(
                          fontSize: 11,
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.s12),
                ...sectionExams.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.s12),
                    child: ExamGradeCard(
                      topic: item.exam.topic,
                      sectionTitle: item.sectionTitle,
                      questionsCount: item.exam.questionsCount,
                      durationMinutes: item.exam.durationMinutes,
                      allowedAttempts: item.exam.allowedAttempts,
                      accent: accent,
                      onTap: () => onExamTap(item),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/cubit/exam_attempts_cubit.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/cubit/exam_attempts_state.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/widgets/attempts_summary_header.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/widgets/attempt_card.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/widgets/grades_empty_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ExamAttemptsScreen extends StatefulWidget {
  final String examId;
  final String? examTitle;

  const ExamAttemptsScreen({
    super.key,
    required this.examId,
    this.examTitle,
  });

  @override
  State<ExamAttemptsScreen> createState() => _ExamAttemptsScreenState();
}

class _ExamAttemptsScreenState extends State<ExamAttemptsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExamAttemptsCubit>().getAttempts(widget.examId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: widget.examTitle ?? "نتائج الطلاب"),
      body: SafeArea(
        child: BlocConsumer<ExamAttemptsCubit, ExamAttemptsState>(
          listenWhen: (previous, current) =>
              current.status == CubitStatus.error &&
              current.apiErrorModel != null &&
              current.attempts.isEmpty,
          listener: (context, state) {
            showDialog(
              context: context,
              builder: (_) => AppErrorDialog(
                apiErrorModel: state.apiErrorModel!,
                onRetry:
                    () =>
                        context
                            .read<ExamAttemptsCubit>()
                            .getAttempts(widget.examId),
              ),
            );
          },
          builder: (context, state) {
            if (state.status == CubitStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if ((state.status == CubitStatus.error ||
                    state.status == CubitStatus.initial) ||
                state.attempts.isEmpty) {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh:
                    () =>
                        context
                            .read<ExamAttemptsCubit>()
                            .getAttempts(widget.examId),
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: GradesEmptyState(
                        icon:
                            state.status == CubitStatus.error
                                ? Icons.error_outline_rounded
                                : Icons.people_outline_rounded,
                        title:
                            state.status == CubitStatus.error
                                ? "حدث خطأ"
                                : "لا توجد نتائج بعد",
                        subtitle:
                            state.status == CubitStatus.error
                                ? "تعذر تحميل نتائج الطلاب، حاول مرة أخرى"
                                : "لم يقم أي طالب بأداء هذا الامتحان حتى الآن",
                      ),
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh:
                  () =>
                      context
                          .read<ExamAttemptsCubit>()
                          .getAttempts(widget.examId),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.s16,
                      AppSizes.s16,
                      AppSizes.s16,
                      AppSizes.s12,
                    ),
                    child: FadeInUp(
                      child: Builder(
                        builder: (_) {
                          final average =
                              state.attempts.isEmpty
                                  ? null
                                  : state.attempts
                                          .map((a) => a.finalScore)
                                          .reduce((a, b) => a + b) /
                                      state.attempts.length;
                          return AttemptsSummaryHeader(
                            totalCount: state.totalCount,
                            examTitle: widget.examTitle ?? "",
                            averageScore: average,
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(child: _buildAttemptsList(state)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAttemptsList(ExamAttemptsState state) {
    final itemCount = state.attempts.length + (state.hasReachedMax ? 0 : 1);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200) {
          context.read<ExamAttemptsCubit>().loadMore();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.s16,
          AppSizes.s4,
          AppSizes.s16,
          AppSizes.s24,
        ),
        itemCount: itemCount,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSizes.s12),
        itemBuilder: (context, index) {
          if (index >= state.attempts.length) {
            return _buildLoader(state);
          }
          final attempt = state.attempts[index];
          return FadeInUp(
            delay: (index < 8 ? index : 0) * 50,
            child: AttemptCard(
              studentName: attempt.studentName,
              finalScore: attempt.finalScore,
              submittedAt: attempt.submittedAt,
              index: index,
              needsTeacherReview: attempt.needsTeacherReview,
              onTap: () {
                AppNavigator.push(
                  context: context,
                  path:
                      AppRoutes.teacherAttemptReviewPage(attempt.id),
                  extra: {
                    "examTitle": widget.examTitle ?? "مراجعة المحاولة",
                    "studentName": attempt.studentName,
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoader(ExamAttemptsState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
      child: Center(
        child:
            state.isLoadingMore
                ? const SizedBox(
                  width: AppSizes.s24,
                  height: AppSizes.s24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
                : const SizedBox.shrink(),
      ),
    );
  }
}

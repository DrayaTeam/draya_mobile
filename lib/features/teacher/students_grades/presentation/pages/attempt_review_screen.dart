import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/cubit/attempt_review_cubit.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/cubit/attempt_review_state.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/widgets/answer_review_card.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/widgets/attempt_review_summary_header.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class AttemptReviewScreen extends StatelessWidget {
  final String attemptId;
  final String? examTitle;
  final String? studentName;

  const AttemptReviewScreen({
    super.key,
    required this.attemptId,
    this.examTitle,
    this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AttemptReviewCubit>(
      create: (_) => getIt<AttemptReviewCubit>()..loadResults(attemptId),
      child: _AttemptReviewView(
        attemptId: attemptId,
        examTitle: examTitle,
        studentName: studentName,
      ),
    );
  }
}

class _AttemptReviewView extends StatelessWidget {
  final String attemptId;
  final String? examTitle;
  final String? studentName;

  const _AttemptReviewView({
    required this.attemptId,
    this.examTitle,
    this.studentName,
  });

  Future<void> _onSaveOverride(BuildContext context, String answerId) async {
    final messenger = ScaffoldMessenger.of(context);
    final success = await context.read<AttemptReviewCubit>().submitOverride(
          attemptId,
          answerId,
        );

    if (success) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text(
            "تم اعتماد الدرجة وتحديث نتيجة الطالب بنجاح",
            textAlign: TextAlign.center,
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: const Text(
            "تعذر حفظ الدرجة، تأكد من إدخال درجة صحيحة وحاول مرة أخرى",
            textAlign: TextAlign.center,
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: examTitle ?? "مراجعة المحاولة"),
      body: SafeArea(
        child: BlocBuilder<AttemptReviewCubit, AttemptReviewState>(
          builder: (context, state) {
            if ((state.status == CubitStatus.initial ||
                    state.status == CubitStatus.loading) &&
                state.results == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state.results == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 40,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "تعذر تحميل بيانات المحاولة",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<AttemptReviewCubit>()
                          .loadResults(attemptId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text("إعادة المحاولة"),
                    ),
                  ],
                ),
              );
            }

            final results = state.results!;

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () =>
                  context.read<AttemptReviewCubit>().loadResults(attemptId),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: results.answers.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AttemptReviewSummaryHeader(
                        results: results,
                        studentName: studentName,
                      ),
                    );
                  }

                  final answerIndex = index - 1;
                  final answer = results.answers[answerIndex];
                  final answerKey = answer.answerId ?? "";

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AnswerReviewCard(
                      key: ValueKey(answerKey.isNotEmpty ? answerKey : answerIndex),
                      answer: answer,
                      index: answerIndex,
                      overrideValue:
                          state.pendingOverrides[answer.answerId ?? ""],
                      isSubmitting: state.isSubmittingOverride,
                      onOverrideChanged: (score) => context
                          .read<AttemptReviewCubit>()
                          .setOverrideScore(answerKey, score),
                      onSaveOverride: () =>
                          _onSaveOverride(context, answerKey),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

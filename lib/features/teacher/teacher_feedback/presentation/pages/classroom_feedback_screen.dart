import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/presentation/cubit/classroom_feedback_cubit.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/presentation/cubit/classroom_feedback_state.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/presentation/widgets/feedback_card.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/presentation/widgets/feedback_summary_card.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ClassroomFeedbackScreen extends StatefulWidget {
  final String classroomId;
  final String? classroomName;

  const ClassroomFeedbackScreen({
    super.key,
    required this.classroomId,
    this.classroomName,
  });

  @override
  State<ClassroomFeedbackScreen> createState() =>
      _ClassroomFeedbackScreenState();
}

class _ClassroomFeedbackScreenState extends State<ClassroomFeedbackScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClassroomFeedbackCubit>().loadFeedback(widget.classroomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.classroomName ?? "تقييمات الفصل",
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: BlocConsumer<ClassroomFeedbackCubit, ClassroomFeedbackState>(
        listener: (context, state) {
          if (state.status == CubitStatus.error &&
              state.apiErrorModel?.error?.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.apiErrorModel!.error!.message!,
                  style: AppTextStyles.body.copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CubitStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state.status == CubitStatus.error && state.items.isEmpty) {
            return _ErrorState(
              message:
                  state.apiErrorModel?.error?.message ?? "تعذر تحميل التقييمات.",
              onRetry: () => context
                  .read<ClassroomFeedbackCubit>()
                  .loadFeedback(widget.classroomId),
            );
          }

          if (state.items.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () =>
                context.read<ClassroomFeedbackCubit>().refresh(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                FeedbackSummaryCard(
                  averageRating: state.averageRating,
                  totalCount: state.totalCount,
                ),
                const SizedBox(height: 18),
                ...state.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final card = Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FeedbackCard(feedback: entry.value),
                  );

                  if (index < 6) {
                    return FadeInUp(delay: index * 50, child: card);
                  }
                  return card;
                }),
                if (state.hasNextPage)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        child: OutlinedButton.icon(
                          onPressed: state.isLoadingMore
                              ? null
                              : () => context
                                  .read<ClassroomFeedbackCubit>()
                                  .loadMore(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                              color: AppColors.primary300,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: state.isLoadingMore
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : const Icon(
                                  Icons.expand_more_rounded,
                                  size: 20,
                                ),
                          label: Text(
                            "تحميل المزيد",
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "حدث خطأ في تحميل التقييمات",
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                "إعادة المحاولة",
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary200, width: 1.5),
              ),
              child: const Icon(
                Icons.reviews_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "لا توجد تقييمات بعد",
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "لم يشارك طلاب هذا الفصل أي تقييم حتى الآن.",
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

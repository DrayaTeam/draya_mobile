import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/pending_reviews_models.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class TeacherDashboardPendingReviewsSection extends StatelessWidget {
  final List<ClassroomPendingReviewsModel> classrooms;
  final bool isLoading;

  const TeacherDashboardPendingReviewsSection({
    super.key,
    required this.classrooms,
    this.isLoading = false,
  });

  int get _totalAttempts => classrooms.fold<int>(
        0,
        (sum, c) =>
            sum +
            c.exams.fold<int>(
              0,
              (s, e) => s + e.pendingReviews.length,
            ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.s16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSizes.s40,
                height: AppSizes.s40,
                decoration: BoxDecoration(
                  color: AppColors.amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                ),
                child: const Icon(
                  Icons.rate_review_rounded,
                  color: AppColors.amber,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.s10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "مراجعات بانتظارك",
                      style: AppTextStyles.h5.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      isLoading
                          ? "جاري التحميل..."
                          : "$_totalAttempts محاولة تحتاج مراجعتك",
                      style: AppTextStyles.label.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isLoading && classrooms.isEmpty) ...[
            const SizedBox(height: AppSizes.s12),
            Text(
              "لا توجد إجابات تحتاج مراجعة حالياً.",
              style: AppTextStyles.body.copyWith(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (!isLoading && classrooms.isNotEmpty)
            ...classrooms.map((c) => _ClassroomAccordion(classroom: c)),
        ],
      ),
    );
  }
}

class _ClassroomAccordion extends StatelessWidget {
  final ClassroomPendingReviewsModel classroom;

  const _ClassroomAccordion({required this.classroom});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        initiallyExpanded: false,
        title: Row(
          children: [
            const Icon(
              Icons.school_rounded,
              size: AppSizes.s16,
              color: AppColors.primary700,
            ),
            const SizedBox(width: AppSizes.s6),
            Expanded(
              child: Text(
                classroom.classroomName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(AppSizes.s6),
              ),
              child: Text(
                "${classroom.exams.length} امتحان",
                style: AppTextStyles.label.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary700,
                ),
              ),
            ),
          ],
        ),
        children: classroom.exams
            .map((exam) => _ExamAccordion(exam: exam))
            .toList(),
      ),
    );
  }
}

class _ExamAccordion extends StatelessWidget {
  final ExamPendingReviewsModel exam;

  const _ExamAccordion({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.s8),
      padding: const EdgeInsets.all(AppSizes.s10),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSizes.s12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.quiz_outlined,
                size: AppSizes.s14,
                color: AppColors.primary700,
              ),
              const SizedBox(width: AppSizes.s6),
              Expanded(
                child: Text(
                  exam.examTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s8),
          ...exam.pendingReviews.map(
            (attempt) => _PendingAttemptTile(attempt: attempt),
          ),
        ],
      ),
    );
  }
}

class _PendingAttemptTile extends StatelessWidget {
  final PendingReviewAttemptModel attempt;

  const _PendingAttemptTile({required this.attempt});

  static final DateFormat _dateFormat = DateFormat("d MMM", "ar");

  Color get _scoreColor {
    if (attempt.score >= 75) return AppColors.success;
    if (attempt.score >= 50) return AppColors.amber;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          AppNavigator.push(
            context: context,
            path: AppRoutes.teacherAttemptReviewPage(attempt.attemptId),
            extra: {"studentName": attempt.studentName},
          );
        },
        borderRadius: BorderRadius.circular(AppSizes.s10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.s6),
          child: Row(
            children: [
              CircleAvatar(
                radius: AppSizes.s14,
                backgroundColor: AppColors.primary100,
                child: Text(
                  attempt.studentName.isNotEmpty
                      ? attempt.studentName[0]
                      : "?",
                  style: AppTextStyles.label.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary700,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.s8),
              Expanded(
                child: Text(
                  attempt.studentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (attempt.submittedAt != null)
                Text(
                  _dateFormat.format(attempt.submittedAt!.toLocal()),
                  style: AppTextStyles.label.copyWith(
                    fontSize: 11,
                    color: AppColors.textDisabled,
                  ),
                ),
              const SizedBox(width: AppSizes.s8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _scoreColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.s6),
                ),
                child: Text(
                  attempt.score.toStringAsFixed(1),
                  style: AppTextStyles.label.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: _scoreColor,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.s4),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: AppColors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

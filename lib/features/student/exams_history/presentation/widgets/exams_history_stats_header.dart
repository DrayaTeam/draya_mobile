import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/exams_history/domain/entity/student_exam_history.dart";
import "package:flutter/material.dart";

class ExamsHistoryStatsHeader extends StatelessWidget {
  final List<StudentExamWithAttempts> exams;

  const ExamsHistoryStatsHeader({super.key, required this.exams});

  int get _totalAttempts => exams.fold(0, (s, e) => s + e.usedAttempts);

  double? get _averageScore {
    final percents = <double>[];
    for (final exam in exams) {
      final percent = exam.latestScorePercent ?? exam.bestAttempt?.scorePercent;
      if (percent != null && percent > 0) percents.add(percent);
    }
    if (percents.isEmpty) return null;
    return percents.reduce((a, b) => a + b) / percents.length;
  }

  int get _masteredCount => exams
      .where((e) => e.attemptStatus == ExamAttemptStatus.completed)
      .length;

  @override
  Widget build(BuildContext context) {
    final average = _averageScore;

    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primary800,
            AppColors.primary600,
            AppColors.primary500,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.s20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary700.withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
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
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.s10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ملخص أدائك",
                      style: AppTextStyles.h5.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${exams.length} امتحان • $_totalAttempts محاولة مسجلة",
                      style: AppTextStyles.label.copyWith(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s14),
          Row(
            children: [
              _StatCard(
                label: "متوسط الدرجات",
                value:
                    average != null ? "${average.toStringAsFixed(0)}%" : "-",
                icon: Icons.percent_rounded,
                color: AppColors.cyan,
              ),
              const SizedBox(width: AppSizes.s8),
              _StatCard(
                label: "امتحانات مكتملة",
                value: "$_masteredCount",
                icon: Icons.task_alt_rounded,
                color: AppColors.success,
              ),
              const SizedBox(width: AppSizes.s8),
              _StatCard(
                label: "قيد المراجعة",
                value: "$_pendingReviewCount",
                icon: Icons.rate_review_rounded,
                color: AppColors.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }

  int get _pendingReviewCount => exams.fold<int>(
        0,
        (sum, exam) =>
            sum +
            exam.attempts.where((a) => a.needsTeacherReview).length,
      );
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.s12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppSizes.s14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Container(
              width: AppSizes.s32,
              height: AppSizes.s32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(height: AppSizes.s6),
            Text(
              value,
              style: AppTextStyles.h4.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label.copyWith(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

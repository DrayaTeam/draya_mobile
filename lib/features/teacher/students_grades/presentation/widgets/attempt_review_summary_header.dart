import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/students_grades/data/models/attempt_review_models.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class AttemptReviewSummaryHeader extends StatelessWidget {
  final AttemptReviewResultsModel results;
  final String? studentName;

  const AttemptReviewSummaryHeader({
    super.key,
    required this.results,
    this.studentName,
  });

  static final DateFormat _dateFormat = DateFormat("d MMM yyyy، h:mm a", "ar");

  int get _pendingCount => results.answers
      .where((a) =>
          a.gradingResult?.needsTeacherReview == true &&
          a.gradingResult?.isFinalized == false)
      .length;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primary700,
            AppColors.primary500,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.s16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary700.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      results.examTitle ?? "مراجعة محاولة",
                      style: AppTextStyles.h4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    if (studentName != null && studentName!.isNotEmpty) ...[
                      const SizedBox(height: AppSizes.s4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person_rounded,
                            size: AppSizes.s14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: AppSizes.s4),
                          Text(
                            studentName!,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s12,
                  vertical: AppSizes.s8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                ),
                child: Column(
                  children: [
                    Text(
                      results.finalScore.toStringAsFixed(1),
                      style: AppTextStyles.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "من ${results.maxScore.toStringAsFixed(1)}",
                      style: AppTextStyles.label.copyWith(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s12),
          Row(
            children: [
              if (results.submittedAt != null) ...[
                const Icon(
                  Icons.schedule_rounded,
                  size: AppSizes.s12,
                  color: Colors.white70,
                ),
                const SizedBox(width: AppSizes.s4),
                Text(
                  _dateFormat.format(results.submittedAt!.toLocal()),
                  style: AppTextStyles.label.copyWith(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
              ] else
                const Spacer(),
              if (_pendingCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.s8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.amber,
                    borderRadius: BorderRadius.circular(AppSizes.s6),
                  ),
                  child: Text(
                    "$_pendingCount إجابة تحتاج مراجعتك",
                    style: AppTextStyles.label.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

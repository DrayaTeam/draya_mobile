import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/exams_history/domain/entity/student_exam_history.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class AttemptHistoryTile extends StatelessWidget {
  final AttemptSummary attempt;
  final int index;
  final String? examId;

  const AttemptHistoryTile({
    super.key,
    required this.attempt,
    required this.index,
    this.examId,
  });

  void _openResults(BuildContext context) {
    if (examId == null || examId!.isEmpty) return;
    if (!attempt.needsTeacherReview && attempt.submittedAt == null) return;
    AppNavigator.push(
      context: context,
      path: AppRoutes.studentExamDetailsPage,
      extra: {
        "examId": examId,
        "attemptId": attempt.id,
      },
    );
  }

  static final DateFormat _dateTimeFormat = DateFormat("d MMM yyyy، h:mm a", "ar");

  static String _formatScore(double value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);

  Color get _scoreColor {
    if (attempt.scorePercent >= 75) return AppColors.success;
    if (attempt.scorePercent >= 50) return AppColors.amber;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final canViewResults =
        examId != null && examId!.isNotEmpty && attempt.submittedAt != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canViewResults ? () => _openResults(context) : null,
        borderRadius: BorderRadius.circular(AppSizes.s12),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppSizes.s12),
            border: Border.all(color: AppColors.border),
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                _scoreColor.withValues(alpha: 0.06),
                Colors.transparent,
              ],
              stops: const [0, 0.35],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s10,
              vertical: AppSizes.s10,
            ),
            child: Row(
              children: [
                Container(
                  width: AppSizes.s32,
                  height: AppSizes.s32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _scoreColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${index + 1}",
                    style: AppTextStyles.label.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: _scoreColor,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.s10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attempt.submittedAt != null
                      ? _dateTimeFormat.format(attempt.submittedAt!.toLocal())
                      : "لم يُسلّم بعد",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (attempt.needsTeacherReview) ...[
                  const SizedBox(height: AppSizes.s4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSizes.s6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.rate_review_outlined,
                          size: 11,
                          color: AppColors.amber,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "قيد مراجعة المعلم",
                          style: AppTextStyles.label.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSizes.s8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s10,
              vertical: AppSizes.s6,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  _scoreColor,
                  _scoreColor.withValues(alpha: 0.75),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.s10),
              boxShadow: [
                BoxShadow(
                  color: _scoreColor.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              attempt.hasMaxScore
                  ? "${_formatScore(attempt.finalScore)} / ${_formatScore(attempt.maxScore!)}"
                  : _formatScore(attempt.finalScore),
              style: AppTextStyles.label.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          if (canViewResults) ...[
            const SizedBox(width: AppSizes.s6),
            const Icon(
              Icons.chevron_left_rounded,
              size: 18,
              color: AppColors.textDisabled,
            ),
          ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

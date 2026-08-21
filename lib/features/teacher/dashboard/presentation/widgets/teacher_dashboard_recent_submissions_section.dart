import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/recent_submissions_item_model.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class TeacherDashboardRecentSubmissionsSection extends StatelessWidget {
  final List<RecentSubmissionsItemModel> submissions;

  const TeacherDashboardRecentSubmissionsSection({
    super.key,
    required this.submissions,
  });

  String _formatSubmissionDate(String rawDate) {
    if (rawDate.isEmpty) return "";
    try {
      final parsed = DateTime.parse(rawDate);
      return DateFormat("d MMM، h:mm a", "ar").format(parsed);
    } catch (_) {
      return rawDate;
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty || parts.first.isEmpty) return "ط";
    if (parts.length == 1) return parts.first[0];
    return "${parts.first[0]}${parts.last[0]}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.primary700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "أحدث تسليمات الاختبارات",
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (submissions.isEmpty)
          _buildEmptyState()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: submissions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = submissions[index];
              return _buildSubmissionCard(item);
            },
          ),
      ],
    );
  }

  Widget _buildSubmissionCard(RecentSubmissionsItemModel item) {
    final score = item.score;
    final scoreFormatted =
        "${score.toStringAsFixed(score.truncateToDouble() == score ? 0 : 1)}%";

    Color scoreBg;
    Color scoreBorder;
    Color scoreTextColor;

    if (score >= 85) {
      scoreBg = const Color(0xFFF0FDF4);
      scoreBorder = const Color(0xFFBBF7D0);
      scoreTextColor = const Color(0xFF15803D);
    } else if (score >= 60) {
      scoreBg = const Color(0xFFF0F9FF);
      scoreBorder = const Color(0xFFBAE6FD);
      scoreTextColor = const Color(0xFF0369A1);
    } else {
      scoreBg = const Color(0xFFFEF2F2);
      scoreBorder = const Color(0xFFFECACA);
      scoreTextColor = const Color(0xFFDC2626);
    }

    final formattedDate = _formatSubmissionDate(item.submittedAt);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        children: [
          // Student Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                _getInitials(item.studentName),
                style: AppTextStyles.label.copyWith(
                  color: const Color(0xFF0369A1),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info: Student Name, Exam Title, Submitted Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.studentName,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.assignment_outlined,
                      size: 13,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.examTitle,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (formattedDate.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: AppColors.textDisabled,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textDisabled,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Score Pill
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: scoreBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: scoreBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  scoreFormatted,
                  style: AppTextStyles.label.copyWith(
                    color: scoreTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "الدرجة",
                  style: AppTextStyles.label.copyWith(
                    color: scoreTextColor.withValues(alpha: 0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color: Color(0xFF9CA3AF),
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "لا توجد تسليمات اختبارات حديثة حتى الآن",
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

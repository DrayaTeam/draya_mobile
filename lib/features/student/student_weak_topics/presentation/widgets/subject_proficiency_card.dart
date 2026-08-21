import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/student_performance_report.dart";
import "package:flutter/material.dart";

class SubjectProficiencyCard extends StatelessWidget {
  final SubjectProficiency subject;

  const SubjectProficiencyCard({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final percent = subject.proficiencyPercent;
    final percentFormatted =
        "${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%";

    Color barColor;
    Color bgLight;
    Color borderColor;
    String statusTitle;

    if (percent >= 80) {
      barColor = const Color(0xFF059669);
      bgLight = const Color(0xFFF0FDF4);
      borderColor = const Color(0xFFBBF7D0);
      statusTitle = "ممتاز";
    } else if (percent >= 60) {
      barColor = const Color(0xFF0284C7);
      bgLight = const Color(0xFFF0F9FF);
      borderColor = const Color(0xFFBAE6FD);
      statusTitle = "جيد";
    } else if (percent >= 40) {
      barColor = const Color(0xFFD97706);
      bgLight = const Color(0xFFFFFBEB);
      borderColor = const Color(0xFFFDE68A);
      statusTitle = "يحتاج تحسين";
    } else {
      barColor = const Color(0xFFE11D48);
      bgLight = const Color(0xFFFFF1F2);
      borderColor = const Color(0xFFFECDD3);
      statusTitle = "ضعيف";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 4),
            blurRadius: 14,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bgLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Icon(
                      Icons.book_rounded,
                      size: 16,
                      color: barColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    subject.subjectName,
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: bgLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusTitle,
                  style: TextStyle(
                    color: barColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "متوسط الكفاءة العامة",
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                percentFormatted,
                style: AppTextStyles.h4.copyWith(
                  color: barColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (percent / 100).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }
}

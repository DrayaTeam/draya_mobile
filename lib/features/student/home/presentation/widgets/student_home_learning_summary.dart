import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart"
    show FaIcon, FontAwesomeIcons;

class StudentHomeLearningSummary extends StatelessWidget {
  final int currentStreak;
  final double overallAverage;
  final int completedLessonsCount;

  const StudentHomeLearningSummary({
    super.key,
    this.currentStreak = 0,
    this.overallAverage = 0.0,
    this.completedLessonsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final streakText = currentStreak > 0
        ? "$currentStreak ${currentStreak == 1 ? "يوم متتالي" : "أيام متتالية"}"
        : "ابدأ سلسلتك اليوم";

    final streakSubtitle = currentStreak > 0
        ? "سلسلة المذاكرة الحالية 🚀"
        : "ذاكر درساً واحداً لبدء السلسلة ✨";

    final averageFormatted = overallAverage > 0
        ? "${overallAverage.toStringAsFixed(overallAverage.truncateToDouble() == overallAverage ? 0 : 1)}%"
        : "0%";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 10),
              blurRadius: 24,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Column(
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      "حافز التعلم اليومي",
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    border: Border.all(
                      color: const Color(0xFFFFD8A8),
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentStreak > 0 ? "نشط الآن 🔥" : "ابدأ اليوم 🎯",
                        style: AppTextStyles.label.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFC2410C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Streak Highlight Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEA580C).withValues(alpha: 0.28),
                    offset: const Offset(0, 8),
                    blurRadius: 16,
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.fire,
                        color: Color(0xFFFEF08A),
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          streakText,
                          style: AppTextStyles.h3.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          streakSubtitle,
                          style: AppTextStyles.label.copyWith(
                            color: const Color(0xFFFEF3C7),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Dual Metric Cards: Cumulative Average & Completed Lessons
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.trending_up_rounded,
                    label: "المتوسط التراكمي",
                    value: averageFormatted,
                    valueColor: const Color(0xFF0369A1),
                    borderColor: const Color(0xFFBAE6FD),
                    backgroundColor: const Color(0xFFF0F9FF),
                    iconColor: const Color(0xFF0284C7),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.menu_book_rounded,
                    label: "الدروس المكتملة",
                    value: "$completedLessonsCount درس",
                    valueColor: const Color(0xFF6D28D9),
                    borderColor: const Color(0xFFDDD6FE),
                    backgroundColor: const Color(0xFFF5F3FF),
                    iconColor: const Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final Color borderColor;
  final Color backgroundColor;
  final Color iconColor;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.borderColor,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: iconColor,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.label.copyWith(
                    color: valueColor.withValues(alpha: 0.85),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

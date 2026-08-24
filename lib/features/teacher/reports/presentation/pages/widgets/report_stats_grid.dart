import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/reports/data/models/performance_report_model.dart";
import "package:flutter/material.dart";

class ReportStatsGrid extends StatelessWidget {
  final PerformanceReportModel report;

  const ReportStatsGrid({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatItem(
        icon: Icons.quiz_outlined,
        label: "الأسئلة المطروحة",
        value: "${report.totalQuestionsAsked}",
        color: AppColors.mathPhysics,
      ),
      _StatItem(
        icon: Icons.task_alt_rounded,
        label: "أسئلة تمت إجابتها",
        value: "${report.totalQuestionsReplied}",
        color: AppColors.chemistryBiology,
      ),
      _StatItem(
        icon: Icons.school_outlined,
        label: "دروس مكتملة",
        value: "${report.completedLessons}",
        color: AppColors.humanities,
      ),
      _StatItem(
        icon: Icons.timer_outlined,
        label: "متوسط زمن الاختبار",
        value: "${report.averageExamDurationMinutes.toStringAsFixed(1)} دقيقة",
        color: AppColors.amber,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.5,
      children: stats.map((stat) => _StatTile(item: stat)).toList(),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _StatTile extends StatelessWidget {
  final _StatItem item;

  const _StatTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(item.icon, color: item.color, size: 19),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.value,
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

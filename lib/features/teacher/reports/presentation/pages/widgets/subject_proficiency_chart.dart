import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/reports/data/models/subject_proficiencies_model.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

class SubjectProficiencyChart extends StatelessWidget {
  final List<SubjectProficienciesModel> subjects;

  const SubjectProficiencyChart({super.key, required this.subjects});

  static const _barColors = [
    AppColors.primary600,
    AppColors.mathPhysics,
    AppColors.amber,
    AppColors.chemistryBiology,
    AppColors.humanities,
    AppColors.cyan,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, progress, _) {
          return AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(_buildChartData(progress)),
          );
        },
      ),
    );
  }

  BarChartData _buildChartData(double progress) {
    return BarChartData(
      maxY: 100,
      alignment: BarChartAlignment.spaceAround,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 25,
        getDrawingHorizontalLine: (value) => const FlLine(
          color: AppColors.border,
          strokeWidth: 1,
          dashArray: [5, 4],
        ),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 25,
            reservedSize: 34,
            getTitlesWidget: (value, meta) => Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                "${value.toInt()}%",
                style: AppTextStyles.label.copyWith(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: (value, meta) =>
                _SubjectLabel(name: subjects[value.toInt()].subjectName),
          ),
        ),
      ),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => AppColors.primary900,
          tooltipBorderRadius: BorderRadius.circular(10),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              "${rod.toY.toStringAsFixed(0)}%",
              AppTextStyles.label.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            );
          },
        ),
      ),
      barGroups: List.generate(subjects.length, (index) {
        final subject = subjects[index];
        final color = _barColors[index % _barColors.length];

        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY:
                  subject.proficiencyPercent.clamp(0, 100).toDouble() *
                  progress,
              width: 20,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [color.withValues(alpha: 0.45), color],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SubjectLabel extends StatelessWidget {
  final String name;

  const _SubjectLabel({required this.name});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: AppTextStyles.label.copyWith(
          fontSize: 10,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

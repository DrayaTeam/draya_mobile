import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/weekly_submissions_activity_item_model.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

class TeacherDashboardWeeklyChart extends StatefulWidget {
  final List<WeeklySubmissionsActivityItemModel> weeklyActivity;

  const TeacherDashboardWeeklyChart({
    super.key,
    required this.weeklyActivity,
  });

  @override
  State<TeacherDashboardWeeklyChart> createState() =>
      _TeacherDashboardWeeklyChartState();
}

class _TeacherDashboardWeeklyChartState
    extends State<TeacherDashboardWeeklyChart> {
  int? _selectedIndex;

  static const Color _accent = Color(0xFF0D9488);

  String _formatDayName(String rawDay) {
    final lower = rawDay.trim().toLowerCase();
    switch (lower) {
      case "sat":
      case "saturday":
      case "السبت":
        return "السبت";
      case "sun":
      case "sunday":
      case "الأحد":
      case "الاحد":
        return "الأحد";
      case "mon":
      case "monday":
      case "الإثنين":
      case "الاثنين":
        return "الإثنين";
      case "tue":
      case "tuesday":
      case "الثلاثاء":
        return "الثلاثاء";
      case "wed":
      case "wednesday":
      case "الأربعاء":
      case "الاربعاء":
        return "الأربعاء";
      case "thu":
      case "thursday":
      case "الخميس":
        return "الخميس";
      case "fri":
      case "friday":
      case "الجمعة":
        return "الجمعة";
      default:
        return rawDay;
    }
  }

  String _shortDayName(String rawDay) {
    final full = _formatDayName(rawDay);
    if (full == "الإثنين") return "الإثن";
    if (full.length > 5 && full.startsWith("ال")) return full.substring(2);
    return full;
  }

  bool _isSelected(int index) =>
      _selectedIndex == index ||
      (_selectedIndex == null && index == widget.weeklyActivity.length - 1);

  String _formatScore(double score) =>
      score.toStringAsFixed(score.truncateToDouble() == score ? 0 : 1);

  @override
  Widget build(BuildContext context) {
    final items = widget.weeklyActivity;
    final totalSubmissions =
        items.fold<int>(0, (sum, item) => sum + item.submissionsCount);

    final selectedItem =
        (_selectedIndex != null && _selectedIndex! < items.length)
            ? items[_selectedIndex!]
            : (items.isNotEmpty ? items.last : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary400, AppColors.primary700],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "نشاط التسليمات الأسبوعي",
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.inbox_rounded,
                    size: 13,
                    color: AppColors.primary700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "$totalSubmissions تسليم",
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary700,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                offset: const Offset(0, 8),
                blurRadius: 20,
                spreadRadius: -4,
              ),
            ],
          ),
          child:
              items.isEmpty ? _buildEmptyState() : _buildChart(items, selectedItem),
        ),
      ],
    );
  }

  Widget _buildChart(
    List<WeeklySubmissionsActivityItemModel> items,
    WeeklySubmissionsActivityItemModel? selectedItem,
  ) {
    final maxCount = items
        .map((e) => e.submissionsCount)
        .reduce((a, b) => a > b ? a : b);
    final maxY = (maxCount + 1).toDouble();

    final spots = List.generate(
      items.length,
      (index) => FlSpot(index.toDouble(), items[index].submissionsCount.toDouble()),
    );

    return Column(
      children: [
        // Selected day summary card
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.15),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: selectedItem != null
              ? Container(
                  key: ValueKey(selectedItem.dayOfWeek),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        AppColors.primary50,
                        AppColors.primary100.withValues(alpha: 0.4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(color: AppColors.primary200),
                            ),
                            child: const Icon(
                              Icons.event_note_rounded,
                              size: 14,
                              color: AppColors.primary700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDayName(selectedItem.dayOfWeek),
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.primary900,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${selectedItem.submissionsCount} تسليم",
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary300),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 12,
                                  color: Color(0xFFF59E0B),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  "متوسط: ${_formatScore(selectedItem.averageScore)}%",
                                  style: AppTextStyles.label.copyWith(
                                    color: AppColors.primary700,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        // Legend
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 14,
                height: 3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_accent, AppColors.primary900],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                "عدد التسليمات",
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Line Chart
        SizedBox(
          height: 190,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY > 4 ? (maxY / 4).ceilToDouble() : 1,
                getDrawingHorizontalLine: (value) => const FlLine(
                  color: AppColors.border,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (value != index.toDouble() ||
                          index < 0 ||
                          index >= items.length) {
                        return const SizedBox.shrink();
                      }
                      final selected = _isSelected(index);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _shortDayName(items[index].dayOfWeek),
                          style: AppTextStyles.label.copyWith(
                            color: selected
                                ? AppColors.primary800
                                : AppColors.textDisabled,
                            fontSize: 10.5,
                            fontWeight:
                                selected ? FontWeight.w800 : FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                handleBuiltInTouches: false,
                touchCallback: (event, response) {
                  if (event is FlTapUpEvent ||
                      event is FlLongPressEnd ||
                      event is FlPanUpdateEvent) {
                    final spots = response?.lineBarSpots;
                    if (spots != null && spots.isNotEmpty) {
                      setState(() {
                        _selectedIndex = spots.first.spotIndex;
                      });
                    }
                  }
                },
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => AppColors.primary900,
                  tooltipBorderRadius: BorderRadius.circular(10),
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  tooltipMargin: 0,
                  getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                    final item = items[spot.spotIndex];
                    return LineTooltipItem(
                      "${item.submissionsCount} تسليم\nمتوسط ${_formatScore(item.averageScore)}%",
                      AppTextStyles.label.copyWith(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }).toList(),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  preventCurveOverShooting: true,
                  barWidth: 3.5,
                  isStrokeCapRound: true,
                  gradient: const LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      AppColors.primary300,
                      _accent,
                      AppColors.primary900,
                    ],
                  ),
                  shadow: Shadow(
                    color: _accent.withValues(alpha: 0.25),
                    offset: const Offset(0, 6),
                    blurRadius: 10,
                  ),
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      final selected = _isSelected(index);
                      return FlDotCirclePainter(
                        radius: selected ? 6 : 4,
                        color: selected ? _accent : Colors.white,
                        strokeWidth: 2.5,
                        strokeColor: selected ? Colors.white : _accent,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _accent.withValues(alpha: 0.22),
                        _accent.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.show_chart_rounded,
                size: 28,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "لا توجد إحصائيات نشاط لهذا الأسبوع بعد",
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

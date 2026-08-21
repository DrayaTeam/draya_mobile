import "dart:math" as math;

import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/weekly_submissions_activity_item_model.dart";
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

  @override
  Widget build(BuildContext context) {
    final items = widget.weeklyActivity;
    final totalSubmissions =
        items.fold<int>(0, (sum, item) => sum + item.submissionsCount);

    final maxCount = items.isEmpty
        ? 1
        : math.max(
            1,
            items.map((e) => e.submissionsCount).reduce(math.max),
          );

    final selectedItem = (_selectedIndex != null &&
            _selectedIndex! >= 0 &&
            _selectedIndex! < items.length)
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
                    color: AppColors.primary700,
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
                color: const Color(0xFFF0FDFA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFCCFBF1)),
              ),
              child: Text(
                "$totalSubmissions تسليم",
                style: AppTextStyles.label.copyWith(
                  color: AppColors.primary700,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
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
          child: items.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    // Highlight selected day stats
                    if (selectedItem != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        margin: const EdgeInsets.only(bottom: (20),),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primary200,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.event_note_rounded,
                                  size: 16,
                                  color: AppColors.primary700,
                                ),
                                const SizedBox(width: 6),
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
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.primary300,
                                    ),
                                  ),
                                  child: Text(
                                    "متوسط: ${selectedItem.averageScore.toStringAsFixed(selectedItem.averageScore.truncateToDouble() == selectedItem.averageScore ? 0 : 1)}%",
                                    style: AppTextStyles.label.copyWith(
                                      color: AppColors.primary700,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    // Bars Row
                    SizedBox(
                      height: 140,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(items.length, (index) {
                          final item = items[index];
                          final isSelected = (_selectedIndex == index) ||
                              (_selectedIndex == null &&
                                  index == items.length - 1);
                          final normalizedHeight = maxCount > 0
                              ? (item.submissionsCount / maxCount) * 85
                              : 0.0;
                          final barHeight = math.max(10.0, normalizedHeight);

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Top count indicator
                                  Text(
                                    "${item.submissionsCount}",
                                    style: AppTextStyles.label.copyWith(
                                      color: isSelected
                                          ? AppColors.primary700
                                          : AppColors.textSecondary,
                                      fontSize: 11,
                                      fontWeight: isSelected
                                          ? FontWeight.w900
                                          : FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Vertical bar
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutCubic,
                                    width: isSelected ? 22 : 16,
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: isSelected
                                          ? const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFF2D9B8A),
                                                Color(0xFF0F4F49),
                                              ],
                                            )
                                          : LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                const Color(0xFF83D1C7)
                                                    .withValues(alpha: 0.5),
                                                const Color(0xFF2D9B8A)
                                                    .withValues(alpha: 0.4),
                                              ],
                                            ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primary700
                                                    .withValues(alpha: 0.3),
                                                offset: const Offset(0, 4),
                                                blurRadius: 8,
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Day text
                                  Text(
                                    _formatDayName(item.dayOfWeek),
                                    style: AppTextStyles.label.copyWith(
                                      color: isSelected
                                          ? AppColors.primary900
                                          : AppColors.textSecondary,
                                      fontSize: 10.5,
                                      fontWeight: isSelected
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
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
                Icons.bar_chart_rounded,
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

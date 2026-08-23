import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";

class TeacherDashboardMetricsGrid extends StatelessWidget {
  final int activeStudents;
  final double classAverage;
  final int examsAwaitingReview;
  final int reportsReadyForReview;
  final int newMessagesCount;

  const TeacherDashboardMetricsGrid({
    super.key,
    required this.activeStudents,
    required this.classAverage,
    required this.examsAwaitingReview,
    required this.reportsReadyForReview,
    this.newMessagesCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final avgFormatted = classAverage > 0
        ? "${classAverage.toStringAsFixed(classAverage.truncateToDouble() == classAverage ? 0 : 1)}%"
        : "0%";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
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
                  "نظرة عامة على الأكاديمية",
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (newMessagesCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 13,
                      color: Color(0xFF1D4ED8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$newMessagesCount رسائل جديدة",
                      style: AppTextStyles.label.copyWith(
                        color: const Color(0xFF1D4ED8),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        // 2x2 Grid of Stat Cards
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: "طلاب نشطون",
                value: activeStudents.toString(),
                subtitle: "تفاعل هذا الشهر",
                icon: Icons.people_alt_outlined,
                primaryColor: const Color(0xFF0F766E),
                badgeText: "نشط ⚡",
                badgeBg: const Color(0xFFCCFBF1),
                badgeTextColor: const Color(0xFF0F766E),
                progress: null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                title: "متوسط الطلاب",
                value: avgFormatted,
                subtitle: classAverage >= 75
                    ? "أداء متميز"
                    : (classAverage >= 55 ? "أداء جيد" : "بحاجة لدعم"),
                icon: Icons.insights_rounded,
                primaryColor: const Color(0xFF0369A1),
                badgeText: classAverage >= 75 ? "ممتاز 🌟" : "عام 📈",
                badgeBg: const Color(0xFFE0F2FE),
                badgeTextColor: const Color(0xFF0369A1),
                progress: (classAverage / 100).clamp(0.0, 1.0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: "امتحانات للمراجعة",
                value: examsAwaitingReview.toString(),
                subtitle: examsAwaitingReview > 0
                    ? "تتطلب اعتمادك"
                    : "تم تصحيح الكل",
                icon: Icons.assignment_turned_in_outlined,
                primaryColor: examsAwaitingReview > 0
                    ? const Color(0xFFC2410C)
                    : const Color(0xFF64748B),
                badgeText: examsAwaitingReview > 0 ? "معلق ⏳" : "مكتمل ✔",
                badgeBg: examsAwaitingReview > 0
                    ? const Color(0xFFFFEDD5)
                    : const Color(0xFFE2E8F0),
                badgeTextColor: examsAwaitingReview > 0
                    ? const Color(0xFFC2410C)
                    : const Color(0xFF475569),
                progress: null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                title: "تقارير جاهزة",
                value: reportsReadyForReview.toString(),
                subtitle: reportsReadyForReview > 0
                    ? "تحليلات جديدة"
                    : "لا تقارير معلقة",
                icon: Icons.auto_graph_rounded,
                primaryColor: const Color(0xFF7C3AED),
                badgeText: "ذكاء اصطناعي ✨",
                badgeBg: const Color(0xFFEDE9FE),
                badgeTextColor: const Color(0xFF6D28D9),
                progress: null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final String badgeText;
  final Color badgeBg;
  final Color badgeTextColor;
  final double? progress;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    required this.badgeText,
    required this.badgeBg,
    required this.badgeTextColor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.07),
            offset: const Offset(0, 8),
            blurRadius: 18,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative corner glow
          Positioned(
            top: -28,
            left: -28,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryColor.withValues(alpha: 0.14),
                    primaryColor.withValues(alpha: 0.02),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          primaryColor.withValues(alpha: 0.16),
                          primaryColor.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: primaryColor,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badgeText,
                        style: AppTextStyles.label.copyWith(
                          color: badgeTextColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                value,
                style: AppTextStyles.h2.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (progress != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, t, _) => LinearProgressIndicator(
                      value: t,
                      minHeight: 5,
                      backgroundColor: AppColors.backgroundMuted,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

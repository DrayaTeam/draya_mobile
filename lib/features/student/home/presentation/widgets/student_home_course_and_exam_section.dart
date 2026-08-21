import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";

class StudentHomeCourseAndExamSection extends StatelessWidget {
  final int subscribedPackagesCount;
  final double overallAverage;

  const StudentHomeCourseAndExamSection({
    super.key,
    this.subscribedPackagesCount = 0,
    this.overallAverage = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final averageFormatted = overallAverage > 0
        ? "${overallAverage.toStringAsFixed(overallAverage.truncateToDouble() == overallAverage ? 0 : 1)}%"
        : "0%";

    // final packagesLabel = subscribedPackagesCount == 1
    //     ? "باقة واحدة"
    //     : "$subscribedPackagesCount باقات";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // // Subscribed Packages Card
          // _CoursePerformanceCard(
          //   title: "الباقات المشترك بها",
          //   value: packagesLabel,
          //   badgeLabel: subscribedPackagesCount > 0
          //       ? "باقات فعالة حالياً"
          //       : "تصفح باقات المواد",
          //   badgeIcon: FontAwesomeIcons.cubes,
          //   badgeColor: const Color(0xFFDCFCE7),
          //   badgeLabelColor: const Color(0xFF166534),
          //   badgeIconColor: const Color(0xFF15803D),
          //   accentGradient: const LinearGradient(
          //     colors: [Color(0xFFF0FDF4), Color(0xFFDCFCE7)],
          //   ),
          //   overlayColor: const Color(0xFF22C55E),
          //   onTap: () {
          //     context.push(AppRoutes.studentEnrolledClassroomsPage);
          //   },
          // ),
          // const SizedBox(height: 14),
          // Overall Subject Performance Card
          _CoursePerformanceCard(
            title: "متوسط أداء المواد",
            value: averageFormatted,
            badgeLabel: overallAverage >= 80
                ? "أداء متميز 🌟"
                : overallAverage >= 50
                    ? "أداء جيد 📈"
                    : "يحتاج لمزيد من التركيز",
            badgeIcon: FontAwesomeIcons.chartLine,
            badgeColor: const Color(0xFFE0F2FE),
            badgeLabelColor: const Color(0xFF0369A1),
            badgeIconColor: const Color(0xFF0284C7),
            accentGradient: const LinearGradient(
              colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
            ),
            overlayColor: const Color(0xFF0EA5E9),
            onTap: () {
              context.push(AppRoutes.studentExamsPage);
            },
          ),
        ],
      ),
    );
  }
}

class _CoursePerformanceCard extends StatelessWidget {
  final String title;
  final String value;
  final String badgeLabel;
  final FaIconData badgeIcon;
  final Color badgeColor;
  final Color badgeLabelColor;
  final Color badgeIconColor;
  final Gradient accentGradient;
  final Color overlayColor;
  final VoidCallback onTap;

  const _CoursePerformanceCard({
    required this.title,
    required this.value,
    required this.badgeLabel,
    required this.badgeIcon,
    required this.badgeColor,
    required this.badgeLabelColor,
    required this.badgeIconColor,
    required this.accentGradient,
    required this.overlayColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 135,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 8),
                blurRadius: 20,
                spreadRadius: -4,
              ),
            ],
            borderRadius: BorderRadius.circular(22),
          ),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                right: 0,
                top: 0,
                width: 90,
                height: 90,
                child: Container(
                  decoration: BoxDecoration(
                    color: overlayColor.withValues(alpha: 0.06),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(90),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Header row with icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            gradient: accentGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: FaIcon(
                              badgeIcon,
                              color: badgeIconColor,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Value and Badge Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badgeLabel,
                            style: AppTextStyles.label.copyWith(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: badgeLabelColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

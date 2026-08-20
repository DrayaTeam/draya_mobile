import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class StudentHomeCourseAndExamSection extends StatelessWidget {
  const StudentHomeCourseAndExamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _CoursePerformanceCard(
            title: "الباقات المشترك بها",
            value: "3 باقات",
            accentGradient: LinearGradient(
              colors: [Color(0xFFF0FDFA), Color(0xFFF0FDFA)],
            ),
            badgeColor: Color(0xFFDCF4EF),
            titleColor: Color(0xFF62748E),
            valueColor: Color(0xFF0F172B),
            badgeBorderColor: Color(0xFF009689),
            badgeIconColor: Color(0xFF009689),
            badgeLabel: "سارية حتى نهاية الترم",
            badgeLabelColor: Color(0xFF009689),
            backgroundColor: Color(0xFFFFFFFF),
            borderColor: Color(0xFFF1F5F9),
            overlayColor: Color(0xFF00BBA7),
            badgeIcon: FontAwesomeIcons.cube,
          ),
          SizedBox(height: AppSizes.s24),
          _CoursePerformanceCard(
            title: "أداء المواد المتوسط",
            value: "87%",
            accentGradient: LinearGradient(
              colors: [Color(0xFFF0F9FF), Color(0xFFF0F9FF)],
            ),
            badgeColor: Color(0xFFD0FAE5),
            titleColor: Color(0xFF62748E),
            valueColor: Color(0xFF0F172B),
            badgeBorderColor: Color(0xFF0084D1),
            badgeIconColor: Color(0xFF0084D1),
            badgeLabel: "+4% هذا الشهر",
            badgeLabelColor: Color(0xFF007A55),
            backgroundColor: Color(0xFFFFFFFF),
            borderColor: Color(0xFFF1F5F9),
            overlayColor: Color(0xFF00A6F4),
            badgeIcon: FontAwesomeIcons.arrowTrendUp,
          ),
        ],
      ),
    );
  }
}

class _CoursePerformanceCard extends StatelessWidget {
  final String title;
  final String value;
  final Gradient accentGradient;
  final Color badgeColor;
  final Color titleColor;
  final Color valueColor;
  final Color badgeBorderColor;
  final Color badgeIconColor;
  final String badgeLabel;
  final Color badgeLabelColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color overlayColor;
  final FaIconData badgeIcon;

  const _CoursePerformanceCard({
    required this.title,
    required this.value,
    required this.accentGradient,
    required this.badgeColor,
    required this.titleColor,
    required this.valueColor,
    required this.badgeBorderColor,
    required this.badgeIconColor,
    required this.badgeLabel,
    required this.badgeLabelColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.overlayColor,
    required this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 162,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 10),
            blurRadius: 15,
            spreadRadius: -3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -4,
          ),
        ],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 1,
            top: 1,
            width: 96,
            height: 96,
            child: Container(
              decoration: BoxDecoration(
                color: overlayColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(999),
                ),
              ),
            ),
          ),
          Positioned(
            top: 25,
            right: 25,
            child: Text(
              title,
              style: AppTextStyles.label.copyWith(
                color: titleColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Positioned(
            top: 25,
            left: 25,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: accentGradient.colors.first,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: FaIcon(
                  badgeIcon,
                  color: badgeIconColor,
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            top: 81,
            right: 25,
            child: Text(
              value,
              style: AppTextStyles.h2.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
          ),
          Positioned(
            top: 121,
            right: 25,
            child: Text(
              badgeLabel,
              style: AppTextStyles.label.copyWith(
                color: badgeLabelColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            left: 25,
            top: 121,
            child: Container(
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Center(
                child: Text(
                  badgeLabel,
                  style: AppTextStyles.label.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: badgeLabelColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

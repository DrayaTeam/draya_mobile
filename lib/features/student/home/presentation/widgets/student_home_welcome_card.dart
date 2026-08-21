import "package:draya_mobile/core/helpers/assets_helper.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class StudentHomeWelcomeCard extends StatelessWidget {
  final String? studentName;
  final int upcomingExamsCount;
  final int streakDays;

  const StudentHomeWelcomeCard({
    super.key,
    this.studentName,
    this.upcomingExamsCount = 0,
    this.streakDays = 0,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat("EEEE، d MMMM y", "ar").format(now);
    final displayName = (studentName != null && studentName!.trim().isNotEmpty)
        ? studentName!.trim()
        : "يا بطل";

    String dynamicSubtitle;
    if (upcomingExamsCount > 0) {
      dynamicSubtitle = upcomingExamsCount == 1
          ? "لديك اختبار واحد مجدول قريباً. واصل الدراسة يومياً وحافظ على لهيب حماسك!"
          : "لديك $upcomingExamsCount اختبارات مجدولة قريباً هذا الأسبوع. واصل المذاكرة وحقق أعلى الدرجات!";
    } else {
      dynamicSubtitle = streakDays > 0
          ? "سلسلة مذاكرتك مستمرة منذ $streakDays أيام متتالية! تابع تقدمك في المواد الدراسية."
          : "ابدأ يومك الدراسي بنشاط، واصل التعلم وحقق أهدافك اليومية!";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: const BoxConstraints(minHeight: 330),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary900.withValues(alpha: 0.2),
              offset: const Offset(0, 16),
              blurRadius: 36,
              spreadRadius: -8,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppImages.studentDashboardImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.primary900,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      const Color(0xFF0D3E39).withValues(alpha: 0.92),
                      const Color(0xFF145A53).withValues(alpha: 0.88),
                      const Color(0xFF1B6D63).withValues(alpha: 0.82),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            // Decorative glow elements
            Positioned(
              top: -30,
              left: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary300.withValues(alpha: 0.15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date Pill
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            formattedDate,
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Welcome Headline
                  Text(
                    "أهلاً بعودتك، $displayName! 👋",
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Dynamic Subtitle
                  Text(
                    dynamicSubtitle,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.surface.withValues(alpha: 0.9),
                      fontSize: 13.5,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Primary Action: Resume study / classrooms
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.push(AppRoutes.studentClassroomsMaterialsPage);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              offset: const Offset(0, 8),
                              blurRadius: 16,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "تابع من حيث توقفت",
                                  style: AppTextStyles.button.copyWith(
                                    color: AppColors.primary900,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: AppColors.primary900,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Secondary Action: Browse enrolled classrooms
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.push(AppRoutes.studentEnrolledClassroomsPage);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "تصفح الفصول والمواد الدراسية",
                              style: AppTextStyles.button.copyWith(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_outward_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

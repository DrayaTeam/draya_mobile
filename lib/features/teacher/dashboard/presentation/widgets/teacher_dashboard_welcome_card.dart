import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class TeacherDashboardWelcomeCard extends StatelessWidget {
  final String? teacherName;
  final int examsAwaitingReview;
  final int reportsReadyForReview;

  const TeacherDashboardWelcomeCard({
    super.key,
    this.teacherName,
    this.examsAwaitingReview = 0,
    this.reportsReadyForReview = 0,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat("EEEE، d MMMM y", "ar").format(now);
    final displayName = (teacherName != null && teacherName!.trim().isNotEmpty)
        ? teacherName!.trim()
        : "أستاذنا الفاضل";

    String dynamicSubtitle;
    if (examsAwaitingReview > 0) {
      dynamicSubtitle = examsAwaitingReview == 1
          ? "لديك اختبار واحد بانتظار مراجعتك وتصحيحه للطلاب."
          : "لديك $examsAwaitingReview اختبارات بانتظار مراجعتك واعتماد درجات الطلاب.";
    } else if (reportsReadyForReview > 0) {
      dynamicSubtitle = reportsReadyForReview == 1
          ? "لديك تقرير أداء تحليلي واحد جاهز للاطلاع والمراجعة."
          : "لديك $reportsReadyForReview تقارير أداء جاهزة للاطلاع عليها ومتابعة مستوى الطلاب.";
    } else {
      dynamicSubtitle = "إليك ملخص شامل لنشاط طلابك وتقدمهم الأكاديمي اليوم.";
    }

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF0F4F49),
            Color(0xFF145A53),
            Color(0xFF1B6D63),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: 0.25),
            offset: const Offset(0, 14),
            blurRadius: 30,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background ambient glows
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary300.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary400.withValues(alpha: 0.12),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Date pill
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
                        color: Colors.white.withValues(alpha: 0.22),
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
                // Greeting
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "أهلاً بك، $displayName! 👨‍🏫",
                        style: AppTextStyles.h2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  dynamicSubtitle,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13.5,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                // Actions
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.push(AppRoutes.examGenerationPage1);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  offset: const Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 16,
                                  color: AppColors.primary800,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    "إنشاء اختبار ذكي",
                                    style: AppTextStyles.button.copyWith(
                                      color: AppColors.primary900,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.push(AppRoutes.classroomsPage);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.school_outlined,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    "إدارة الفصول",
                                    style: AppTextStyles.button.copyWith(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}

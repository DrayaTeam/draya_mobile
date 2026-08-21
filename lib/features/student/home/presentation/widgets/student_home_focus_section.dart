import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/home/domain/entity/student_dashboard.dart";
import "package:flutter/material.dart";

class StudentHomeFocusSection extends StatelessWidget {
  final List<PointNeedingFocus> pointsNeedingFocus;

  const StudentHomeFocusSection({
    super.key,
    this.pointsNeedingFocus = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (pointsNeedingFocus.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with AI Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.ai700,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "نقاط تحتاج إلى تركيز",
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
                  color: AppColors.ai50,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.ai300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 13,
                      color: AppColors.ai700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "تحليل الذكاء الاصطناعي",
                      style: AppTextStyles.label.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ai700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "المفاهيم التي تحتاج إلى مراجعة وتدريب لرفع مستوى إتقانك بها",
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 14),
          // Focus Topics List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pointsNeedingFocus.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final focus = pointsNeedingFocus[index];
              final percent = focus.proficiencyPercent;
              final percentFormatted =
                  "${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%";

              Color statusColor;
              Color statusBg;
              Color statusBorder;
              String statusLabel;

              if (percent < 50) {
                statusColor = const Color(0xFFE11D48);
                statusBg = const Color(0xFFFFF1F2);
                statusBorder = const Color(0xFFFECDD3);
                statusLabel = "يحتاج مراجعة عاجلة";
              } else if (percent < 75) {
                statusColor = const Color(0xFFD97706);
                statusBg = const Color(0xFFFFFBEB);
                statusBorder = const Color(0xFFFDE68A);
                statusLabel = "متوسط الإتقان";
              } else {
                statusColor = const Color(0xFF059669);
                statusBg = const Color(0xFFF0FDF4);
                statusBorder = const Color(0xFFBBF7D0);
                statusLabel = "إتقان جيد";
              }

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      offset: const Offset(0, 6),
                      blurRadius: 16,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Topic Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                focus.topicName,
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: statusBorder),
                                ),
                                child: Text(
                                  statusLabel,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "مستوى الإتقان",
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              percentFormatted,
                              style: AppTextStyles.h3.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Proficiency Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (percent / 100).clamp(0.0, 1.0),
                        minHeight: 7,
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Action: AI Revision Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          AppNavigator.push(
                            context: context,
                            path: AppRoutes.studentWeakTopicsPage,
                            extra: {
                              "initialTopic": focus.topicName,
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.ai700,
                                AppColors.ai900,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.ai700.withValues(alpha: 0.25),
                                offset: const Offset(0, 4),
                                blurRadius: 10,
                                spreadRadius: -2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "مراجعة المفهوم مع المساعد الذكي",
                                style: AppTextStyles.button.copyWith(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

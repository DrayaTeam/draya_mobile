import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_exam_model.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/intl.dart";

enum ExamAccessStatus {
  active,
  upcoming,
  expired,
}

class TeacherExamCardItem extends StatelessWidget {
  final SectionExamModel exam;
  final String classroomName;
  final String sectionTitle;
  final VoidCallback onViewQuestions;

  const TeacherExamCardItem({
    super.key,
    required this.exam,
    required this.classroomName,
    required this.sectionTitle,
    required this.onViewQuestions,
  });

  ExamAccessStatus _getAccessStatus() {
    final now = DateTime.now().toUtc();
    if (exam.startDate != null && now.isBefore(exam.startDate!.toUtc())) {
      return ExamAccessStatus.upcoming;
    }
    if (exam.endDate != null && now.isAfter(exam.endDate!.toUtc())) {
      return ExamAccessStatus.expired;
    }
    return ExamAccessStatus.active;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("d MMM yyyy", "ar");
    final dateTimeFormat = DateFormat("d MMM - hh:mm a", "ar");
    final dateStr = dateFormat.format(exam.createdAt);
    final status = _getAccessStatus();

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status == ExamAccessStatus.active
              ? AppColors.primary100
              : AppColors.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: status == ExamAccessStatus.active
                ? AppColors.primary.withValues(alpha: 0.06)
                : const Color.fromRGBO(17, 24, 39, 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onViewQuestions();
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary200),
                      ),
                      child: Text(
                        classroomName,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    _buildStatusBadge(status),
                  ],
                ),
                const SizedBox(height: AppSizes.s12),
                Text(
                  exam.topic,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "القسم: $sectionTitle • أضيف في $dateStr",
                  textAlign: TextAlign.right,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: AppSizes.s12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                      icon: Icons.quiz_outlined,
                      text: "${exam.questionsCount} أسئلة",
                      color: AppColors.primary,
                      bgColor: AppColors.primary50,
                    ),
                    if (exam.durationMinutes != null &&
                        exam.durationMinutes! > 0)
                      _buildInfoChip(
                        icon: Icons.timer_outlined,
                        text: "${exam.durationMinutes} دقيقة",
                        color: AppColors.amber,
                        bgColor: AppColors.amber.withValues(alpha: 0.12),
                      ),
                    if (exam.allowedAttempts != null &&
                        exam.allowedAttempts! > 0)
                      _buildInfoChip(
                        icon: Icons.replay_rounded,
                        text: "${exam.allowedAttempts} محاولات مسموحة",
                        color: AppColors.ai700,
                        bgColor: AppColors.ai100,
                      ),
                  ],
                ),
                if (status == ExamAccessStatus.upcoming &&
                    exam.startDate != null) ...[
                  const SizedBox(height: AppSizes.s8),
                  _buildDateBanner(
                    icon: Icons.info_outline,
                    color: AppColors.mathPhysics,
                    text:
                        "يبدأ الامتحان في: ${dateTimeFormat.format(exam.startDate!.toLocal())}",
                  ),
                ],
                if (status == ExamAccessStatus.active &&
                    exam.endDate != null) ...[
                  const SizedBox(height: AppSizes.s8),
                  _buildDateBanner(
                    icon: Icons.alarm,
                    color: AppColors.amber,
                    text:
                        "ينتهي موعد الامتحان في: ${dateTimeFormat.format(exam.endDate!.toLocal())}",
                  ),
                ],
                const SizedBox(height: AppSizes.s16),
                _buildViewQuestionsButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewQuestionsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onViewQuestions,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary50,
          foregroundColor: AppColors.primary700,
          disabledBackgroundColor: AppColors.backgroundMuted,
          padding: const EdgeInsets.symmetric(vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.primary200),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.visibility_outlined, size: 18),
        label: Text(
          "عرض الأسئلة والإجابات الصحيحة",
          style: AppTextStyles.label.copyWith(
            color: AppColors.primary700,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildDateBanner({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.label.copyWith(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ExamAccessStatus status) {
    Color color;
    Color bgColor;
    String label;
    IconData icon;

    switch (status) {
      case ExamAccessStatus.active:
        color = AppColors.chemistryBiology;
        bgColor = AppColors.chemistryBiology.withValues(alpha: 0.12);
        label = "متاح الآن";
        icon = Icons.check_circle_rounded;
      case ExamAccessStatus.upcoming:
        color = AppColors.mathPhysics;
        bgColor = AppColors.mathPhysics.withValues(alpha: 0.12);
        label = "قريباً";
        icon = Icons.schedule_rounded;
      case ExamAccessStatus.expired:
        color = AppColors.error;
        bgColor = AppColors.error.withValues(alpha: 0.12);
        label = "منتهي";
        icon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.label.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

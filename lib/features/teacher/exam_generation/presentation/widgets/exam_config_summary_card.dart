import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";
import "package:flutter/material.dart";

class ExamConfigSummaryCard extends StatelessWidget {
  final String topic;
  final String? classroomName;
  final String? subjectName;
  final String? sectionTitle;
  final String difficultyLevel;
  final List<QuestionRequirementModel> questionRequirements;
  final int? durationMinutes;
  final int? allowedAttempts;

  const ExamConfigSummaryCard({
    super.key,
    required this.topic,
    this.classroomName,
    this.subjectName,
    this.sectionTitle,
    required this.difficultyLevel,
    required this.questionRequirements,
    this.durationMinutes,
    this.allowedAttempts,
  });

  int get _totalQuestions =>
      questionRequirements.fold(0, (sum, r) => sum + r.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary50,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary200, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.04),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.isNotEmpty ? topic : "امتحان جديد",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.h5.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _buildSubheaderText(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDifficultyBadge(difficultyLevel),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.primary100),
          const SizedBox(height: 12),

          // Metadata Chips Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoBadge(
                icon: Icons.quiz_outlined,
                label: "$_totalQuestions أسئلة مطلوبة",
                color: AppColors.primary700,
                bgColor: AppColors.primary50,
                borderColor: AppColors.primary200,
              ),
              if (durationMinutes != null && durationMinutes! > 0)
                _buildInfoBadge(
                  icon: Icons.timer_outlined,
                  label: "$durationMinutes دقيقة",
                  color: AppColors.chemistryBiology,
                  bgColor: AppColors.chemistryBiology.withValues(alpha: 0.08),
                  borderColor:
                      AppColors.chemistryBiology.withValues(alpha: 0.25),
                ),
              if (allowedAttempts != null && allowedAttempts! > 0)
                _buildInfoBadge(
                  icon: Icons.repeat_rounded,
                  label: allowedAttempts == 1
                      ? "محاولة واحدة"
                      : "$allowedAttempts محاولات",
                  color: AppColors.ai700,
                  bgColor: AppColors.ai50,
                  borderColor: AppColors.ai300,
                ),
              if (sectionTitle != null && sectionTitle!.isNotEmpty)
                _buildInfoBadge(
                  icon: Icons.folder_open_rounded,
                  label: sectionTitle!,
                  color: AppColors.amber,
                  bgColor: AppColors.amber.withValues(alpha: 0.1),
                  borderColor: AppColors.amber.withValues(alpha: 0.3),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildSubheaderText() {
    final parts = <String>[];
    if (classroomName != null && classroomName!.isNotEmpty) {
      parts.add(classroomName!);
    }
    if (subjectName != null && subjectName!.isNotEmpty) {
      parts.add(subjectName!);
    }
    if (parts.isEmpty) {
      return "إعدادات الامتحان";
    }
    return parts.join(" • ");
  }

  Widget _buildDifficultyBadge(String level) {
    String label;
    Color color;

    switch (level.toLowerCase()) {
      case "hard":
        label = "متقدم 🔴";
        color = AppColors.error;
      case "medium":
        label = "متوسط 🟡";
        color = AppColors.amber;
      default:
        label = "سهل 🟢";
        color = AppColors.chemistryBiology;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

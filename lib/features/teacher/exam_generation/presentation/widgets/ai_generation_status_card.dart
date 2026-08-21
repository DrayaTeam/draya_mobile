import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class AiGenerationStatusCard extends StatelessWidget {
  final ExamGenerationStatusModel status;

  const AiGenerationStatusCard({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.ai300, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.ai700.withValues(alpha: 0.09),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Animated Pulse AI Icon
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.ai700, AppColors.ai900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.ai700.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.wandMagicSparkles,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            status.localizedStatusArabic,
            textAlign: TextAlign.center,
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.ai900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "يقوم محرك الذكاء الاصطناعي بربط المفاهيم وصياغة أسئلة متوافقة مع المحتوى.",
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Linear animated loading bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              minHeight: 7,
              color: AppColors.ai700,
              backgroundColor: AppColors.ai100,
            ),
          ),
          const SizedBox(height: 20),

          // Multi-step progress bullets
          _buildStageRow(
            stageNum: 1,
            label: "استرجاع ملفات ومحاضرات القسم (RAG)",
            isDone: status.status >= 2,
            isCurrent: status.status == 1,
          ),
          const SizedBox(height: 10),
          _buildStageRow(
            stageNum: 2,
            label: "صياغة الأسئلة والخيارات المتعددة",
            isDone: status.status >= 3,
            isCurrent: status.status == 2,
          ),
          const SizedBox(height: 10),
          _buildStageRow(
            stageNum: 3,
            label: "التحقق من صحة الإجابات ومعايير التصحيح",
            isDone: status.isCompleted || status.isCompletedWithWarning,
            isCurrent: status.status == 3,
          ),
        ],
      ),
    );
  }

  Widget _buildStageRow({
    required int stageNum,
    required String label,
    required bool isDone,
    required bool isCurrent,
  }) {
    final Color iconColor;
    final IconData icon;

    if (isDone) {
      iconColor = AppColors.chemistryBiology;
      icon = Icons.check_circle_rounded;
    } else if (isCurrent) {
      iconColor = AppColors.ai700;
      icon = Icons.radio_button_checked_rounded;
    } else {
      iconColor = AppColors.textDisabled;
      icon = Icons.radio_button_off_rounded;
    }

    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 12,
              fontWeight: isCurrent || isDone ? FontWeight.w700 : FontWeight.w500,
              color: isCurrent
                  ? AppColors.ai900
                  : isDone
                      ? AppColors.textPrimary
                      : AppColors.textDisabled,
            ),
          ),
        ),
      ],
    );
  }
}

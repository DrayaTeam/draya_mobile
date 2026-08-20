import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:flutter/material.dart";

class ExamGradingScreen extends StatelessWidget {
  final GradingJobStatus? jobStatus;
  final VoidCallback? onCancel;

  const ExamGradingScreen({
    super.key,
    this.jobStatus,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.s24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated AI Brain / Grading icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary700, AppColors.ai700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ai700.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.s24),

              // Title
              Text(
                "جاري تصحيح الامتحان...",
                textAlign: TextAlign.center,
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.s8),

              // Subtitle
              Text(
                "يتم الآن تصحيح إجاباتك وتحليل الأسئلة المقالية بواسطة الذكاء الاصطناعي.",
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSizes.s24),

              // Steps indicators
              _buildStepRow(
                icon: Icons.check_circle_rounded,
                text: "استلام الإجابات وتسجيل وقت التسليم",
                isDone: true,
              ),
              const SizedBox(height: 10),
              _buildStepRow(
                icon: Icons.auto_awesome_rounded,
                text: "تصحيح الأسئلة الموضوعية والمقالية",
                isDone: jobStatus?.status == GradingJobState.grading ||
                    jobStatus?.status == GradingJobState.completed,
                isActive: jobStatus?.status == GradingJobState.grading,
              ),
              const SizedBox(height: 10),
              _buildStepRow(
                icon: Icons.analytics_outlined,
                text: "تجهيز تقرير الدرجات والملاحظات",
                isDone: jobStatus?.status == GradingJobState.completed,
                isActive: jobStatus?.status == GradingJobState.grading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow({
    required IconData icon,
    required String text,
    bool isDone = false,
    bool isActive = false,
  }) {
    Color color;
    if (isDone) {
      color = AppColors.success;
    } else if (isActive) {
      color = AppColors.ai700;
    } else {
      color = AppColors.foregroundMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.label.copyWith(
                color: color,
                fontWeight: isDone || isActive ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

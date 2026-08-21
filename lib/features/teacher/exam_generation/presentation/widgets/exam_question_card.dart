import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class ExamQuestionCard extends StatelessWidget {
  final TeacherExamQuestionModel question;
  final int index;
  final VoidCallback onAiRefine;
  final VoidCallback onManualEdit;
  final VoidCallback onDelete;

  const ExamQuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.onAiRefine,
    required this.onManualEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.035),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Badges & Delete Button
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "السؤال ${index + 1}",
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary700,
                      fontWeight: FontWeight.w900,
                      fontSize: 11.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildTypeBadge(question.type),
                const SizedBox(width: 8),
                _buildDifficultyBadge(question.difficulty),
                const Spacer(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: AppColors.error.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Question Text
            Text(
              question.text,
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 12),

            // Options Preview
            if (question.options.isNotEmpty) ...[
              Column(
                children: question.options.map((opt) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: opt.isCorrect
                          ? AppColors.chemistryBiology.withValues(alpha: 0.08)
                          : AppColors.backgroundMuted,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: opt.isCorrect
                            ? AppColors.chemistryBiology.withValues(alpha: 0.35)
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          opt.isCorrect
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: 16,
                          color: opt.isCorrect
                              ? AppColors.chemistryBiology
                              : AppColors.textDisabled,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            opt.text,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 12.5,
                              fontWeight: opt.isCorrect
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: opt.isCorrect
                                  ? AppColors.chemistryBiology
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (opt.isCorrect)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.chemistryBiology,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "الإجابة الصحيحة",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],

            // Rubric preview if Essay / ShortAnswer
            if (question.rubric != null && question.rubric!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.ai50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.ai300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.grading_rounded,
                      size: 16,
                      color: AppColors.ai700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "معيار التصحيح: ${question.rubric!}",
                        style: AppTextStyles.body.copyWith(
                          fontSize: 11.5,
                          color: AppColors.ai900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Action Buttons (AI Refine & Manual Edit)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAiRefine,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.ai700,
                      side: const BorderSide(color: AppColors.ai300),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const FaIcon(
                      FontAwesomeIcons.wandMagicSparkles,
                      size: 13,
                    ),
                    label: const Text(
                      "تحسين بالذكاء الاصطناعي",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onManualEdit,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary700,
                      side: const BorderSide(color: AppColors.primary300),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text(
                      "تعديل يدوي",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    String label;
    Color color;

    switch (type.toLowerCase()) {
      case "multiplechoice":
      case "mcq":
        label = "اختيار من متعدد";
        color = AppColors.primary;
      case "truefalse":
        label = "صح / خطأ";
        color = AppColors.chemistryBiology;
      case "essay":
        label = "مقالي";
        color = AppColors.ai700;
      case "shortanswer":
        label = "إجابة قصيرة";
        color = AppColors.cyan;
      case "fillintheblank":
        label = "أكمل الفراغ";
        color = AppColors.amber;
      default:
        label = type;
        color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10.5,
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    String label;
    Color color;

    switch (difficulty.toLowerCase()) {
      case "easy":
        label = "سهل";
        color = AppColors.chemistryBiology;
      case "medium":
        label = "متوسط";
        color = AppColors.amber;
      case "hard":
        label = "متقدم";
        color = AppColors.error;
      default:
        label = difficulty;
        color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10.5,
        ),
      ),
    );
  }
}

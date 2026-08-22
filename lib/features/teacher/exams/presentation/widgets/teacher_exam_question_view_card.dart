import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";
import "package:flutter/material.dart";

class TeacherExamQuestionViewCard extends StatelessWidget {
  final TeacherExamQuestionModel question;
  final int index;

  static const _optionLetters = ["أ", "ب", "ج", "د", "هـ", "و"];

  const TeacherExamQuestionViewCard({
    super.key,
    required this.question,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.s16),
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
              ],
            ),
            const SizedBox(height: 12),
            Text(
              question.text,
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.45,
              ),
            ),
            if (question.options.isNotEmpty) ...[
              const SizedBox(height: 12),
              Column(
                children:
                    question.options.asMap().entries.map((entry) {
                  final optionIndex = entry.key;
                  final opt = entry.value;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: opt.isCorrect
                          ? AppColors.chemistryBiology.withValues(alpha: 0.08)
                          : AppColors.backgroundMuted,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: opt.isCorrect
                            ? AppColors.chemistryBiology
                                .withValues(alpha: 0.4)
                            : AppColors.border,
                        width: opt.isCorrect ? 1.4 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: opt.isCorrect
                                ? AppColors.chemistryBiology
                                : AppColors.surface,
                            border: Border.all(
                              color: opt.isCorrect
                                  ? AppColors.chemistryBiology
                                  : AppColors.borderStrong,
                              width: 1.2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: opt.isCorrect
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 15,
                                  color: Colors.white,
                                )
                              : Text(
                                  optionIndex < _optionLetters.length
                                      ? _optionLetters[optionIndex]
                                      : "${optionIndex + 1}",
                                  style: AppTextStyles.label.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            opt.text,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 12.5,
                              fontWeight: opt.isCorrect
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: opt.isCorrect
                                  ? AppColors.primary900
                                  : AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (opt.isCorrect) ...[
                          const SizedBox(width: 6),
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
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
            if (question.rubric != null && question.rubric!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.ai50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.ai100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.grading_rounded,
                          size: 15,
                          color: AppColors.ai700,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "معيار التصحيح والإجابة النموذجية",
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.ai700,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      question.rubric!,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 11.5,
                        color: AppColors.ai900,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
            ],
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

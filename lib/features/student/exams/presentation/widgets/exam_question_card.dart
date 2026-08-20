import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:flutter/material.dart";

class ExamQuestionCard extends StatelessWidget {
  final ExamQuestion question;
  final int questionIndex;
  final int totalQuestions;
  final String? selectedOptionId;
  final String? answerText;
  final void Function(String optionId) onOptionSelected;
  final void Function(String text) onTextChanged;

  const ExamQuestionCard({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.totalQuestions,
    this.selectedOptionId,
    this.answerText,
    required this.onOptionSelected,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.04),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question header: Type pill + difficulty
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
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getTypeIcon(question.type),
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      question.type.toDisplayString(),
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDifficultyBadge(question.difficulty),
            ],
          ),
          const SizedBox(height: AppSizes.s16),

          // Question Text
          Text(
            question.text,
            textAlign: TextAlign.right,
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSizes.s24),

          // Dynamic question input based on type
          if (question.type == QuestionType.multipleChoice ||
              question.type == QuestionType.trueFalse)
            ..._buildOptionList()
          else if (question.type == QuestionType.essay)
            _buildEssayInput()
          else
            _buildShortAnswerInput(),
        ],
      ),
    );
  }

  IconData _getTypeIcon(QuestionType type) {
    switch (type) {
      case QuestionType.multipleChoice:
        return Icons.radio_button_checked_rounded;
      case QuestionType.trueFalse:
        return Icons.check_circle_outline_rounded;
      case QuestionType.essay:
        return Icons.article_outlined;
      case QuestionType.fillInTheBlank:
        return Icons.edit_note_rounded;
      case QuestionType.shortAnswer:
        return Icons.short_text_rounded;
    }
  }

  Widget _buildDifficultyBadge(String difficulty) {
    Color color;
    String label;
    switch (difficulty.toLowerCase().trim()) {
      case "easy":
        color = AppColors.success;
        label = "سهل";
        break;
      case "medium":
        color = AppColors.amber;
        label = "متوسط";
        break;
      case "hard":
        color = AppColors.error;
        label = "صعب";
        break;
      default:
        color = AppColors.foregroundMuted;
        label = difficulty;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  List<Widget> _buildOptionList() {
    return question.options.map((option) {
      final isSelected = selectedOptionId == option.id;
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.s12),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onOptionSelected(option.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(AppSizes.s16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary50
                  : AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.borderStrong,
                width: isSelected ? 1.8 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.foregroundMuted,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.text,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body.copyWith(
                      color: isSelected
                          ? AppColors.primary900
                          : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildEssayInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "اكتب إجابتك بالتفصيل أدناه:",
          style: AppTextStyles.label.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: answerText,
          maxLines: 7,
          minLines: 4,
          textAlign: TextAlign.right,
          enableInteractiveSelection: false, // Anti-cheating: disable paste
          style: AppTextStyles.body.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: "اكتب إجابتك هنا...",
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.textDisabled,
              fontSize: 13,
            ),
            fillColor: AppColors.backgroundSecondary,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.borderStrong),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.borderStrong),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.8),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: onTextChanged,
        ),
      ],
    );
  }

  Widget _buildShortAnswerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "اكتب إجابتك الموجزة:",
          style: AppTextStyles.label.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: answerText,
          maxLines: 2,
          textAlign: TextAlign.right,
          enableInteractiveSelection: false, // Anti-cheating: disable paste
          style: AppTextStyles.body.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: "اكتب الإجابة هنا...",
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.textDisabled,
              fontSize: 13,
            ),
            fillColor: AppColors.backgroundSecondary,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.borderStrong),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.borderStrong),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.8),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: onTextChanged,
        ),
      ],
    );
  }
}

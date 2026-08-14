import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ExamQuestionCard extends StatelessWidget {
  final String question;
  final List<String> choices;
  final int? selectedChoiceIndex;
  final void Function(int index) onChoiceSelected;

  const ExamQuestionCard({
    super.key,
    required this.question,
    required this.choices,
    required this.selectedChoiceIndex,
    required this.onChoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question,
          textAlign: TextAlign.right,
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSizes.s24),
        ...List.generate(
          choices.length,
          (index) => _buildChoiceTile(
            choice: choices[index],
            isSelected: selectedChoiceIndex == index,
            onTap: () => onChoiceSelected(index),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceTile({
    required String choice,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.s12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s16,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary700.withValues(alpha: 0.12)
                : AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary700 : AppColors.borderStrong,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            choice,
            textAlign: TextAlign.right,
            style: AppTextStyles.body.copyWith(
              color: isSelected ? AppColors.primary900 : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

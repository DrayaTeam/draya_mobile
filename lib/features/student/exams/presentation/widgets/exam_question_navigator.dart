import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ExamQuestionNavigator extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final bool Function(int index) isAnswered;
  final void Function(int index) onQuestionTap;

  const ExamQuestionNavigator({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.isAnswered,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: totalQuestions,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isCurrent = index == currentIndex;
          final answered = isAnswered(index);

          Color backgroundColor;
          Color textColor;
          Border? border;

          if (isCurrent) {
            backgroundColor = AppColors.primary;
            textColor = Colors.white;
            border = Border.all(color: AppColors.primary800, width: 2);
          } else if (answered) {
            backgroundColor = AppColors.success.withValues(alpha: 0.15);
            textColor = AppColors.success;
            border = Border.all(
              color: AppColors.success.withValues(alpha: 0.4),
              width: 1.2,
            );
          } else {
            backgroundColor = AppColors.backgroundSecondary;
            textColor = AppColors.foregroundMuted;
            border = Border.all(color: AppColors.border, width: 1);
          }

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onQuestionTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: border,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: AppTextStyles.label.copyWith(
                    color: textColor,
                    fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";

class ExamGenerationSteps extends StatelessWidget {
  final int currentStep;

  const ExamGenerationSteps({super.key, required this.currentStep});

  static const List<_StepInfo> _steps = [
    _StepInfo(
      step: 1,
      title: "الإعداد والمحتوى",
      subtitle: "المادة والمواضيع",
      icon: Icons.tune_rounded,
    ),
    _StepInfo(
      step: 2,
      title: "الوقت والجدولة",
      subtitle: "المدة والمحاولات",
      icon: Icons.schedule_rounded,
    ),
    _StepInfo(
      step: 3,
      title: "مراجعة الأسئلة",
      subtitle: "الاعتماد والتعديل",
      icon: Icons.checklist_rtl_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s12,
        vertical: AppSizes.s14,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.03),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          for (int i = 0; i < _steps.length; i++) ...[
            Expanded(
              child: _buildStepItem(
                stepInfo: _steps[i],
                isCompleted: currentStep > _steps[i].step,
                isActive: currentStep == _steps[i].step,
                isUpcoming: currentStep < _steps[i].step,
              ),
            ),
            if (i < _steps.length - 1)
              _buildStepConnector(isCompleted: currentStep > i + 1),
          ],
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required _StepInfo stepInfo,
    required bool isCompleted,
    required bool isActive,
    required bool isUpcoming,
  }) {
    final Color badgeBg;
    final Color badgeContentColor;
    final Color titleColor;
    final FontWeight titleWeight;

    if (isActive) {
      badgeBg = AppColors.primary;
      badgeContentColor = Colors.white;
      titleColor = AppColors.primary700;
      titleWeight = FontWeight.w800;
    } else if (isCompleted) {
      badgeBg = AppColors.chemistryBiology;
      badgeContentColor = Colors.white;
      titleColor = AppColors.textPrimary;
      titleWeight = FontWeight.w700;
    } else {
      badgeBg = AppColors.backgroundMuted;
      badgeContentColor = AppColors.textDisabled;
      titleColor = AppColors.textDisabled;
      titleWeight = FontWeight.w500;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: badgeBg,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive
                  ? AppColors.primary300
                  : isCompleted
                      ? AppColors.chemistryBiology.withValues(alpha: 0.4)
                      : AppColors.border,
              width: isActive ? 2 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 20,
                  )
                : Text(
                    "${stepInfo.step}",
                    style: TextStyle(
                      color: badgeContentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          stepInfo.title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.label.copyWith(
            fontSize: 11.5,
            color: titleColor,
            fontWeight: titleWeight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          stepInfo.subtitle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body.copyWith(
            fontSize: 9.5,
            color: isActive
                ? AppColors.primary500
                : isCompleted
                    ? AppColors.textSecondary
                    : AppColors.textDisabled,
            fontWeight: isCompleted || isActive
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector({required bool isCompleted}) {
    return Container(
      width: 24,
      height: 2,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.chemistryBiology : AppColors.borderStrong,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _StepInfo {
  final int step;
  final String title;
  final String subtitle;
  final IconData icon;

  const _StepInfo({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

import 'package:draya_mobile/core/helpers/app_extensions.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

class ExamGenerationSteps extends StatelessWidget {
  final int currentStep;
  const ExamGenerationSteps({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s8,
        children: [
          Expanded(
            child: _stepWidget(
              context: context,
              step: 1,
              title: "الاعداد وتصفية المحتوى",
              isActive: currentStep == 1,
            ),
          ),
          Expanded(
            child: _stepWidget(
              context: context,
              step: 2,
              title: "مراجعة الاسئلة",
              isActive: currentStep == 2,
            ),
          ),
          Expanded(
            child: _stepWidget(
              context: context,
              step: 3,
              title: "اعدادات الوقت والتوزيع",
              isActive: currentStep == 3,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _stepWidget({
  required BuildContext context,
  required int step,
  required String title,
  required bool isActive,
}) {
  return Container(
    padding: const EdgeInsets.all(AppSizes.s8),
    decoration: BoxDecoration(
      color: isActive ? AppColors.primary500 : AppColors.primary50,
      borderRadius: BorderRadius.circular(AppSizes.s20),
      border: Border.all(
        color: AppColors.primary200,
        width: AppSizes.s1,
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: AppSizes.s8,
      children: [
        Container(
          width: AppSizes.s20,
          height: AppSizes.s20,
          decoration: BoxDecoration(
            color: AppColors.primary200,
            borderRadius: BorderRadius.circular(AppSizes.s20),
          ),
          child: Text(
            step.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            title,
            style: context.textTheme.labelSmall,
          ),
        ),
      ],
    ),
  );
}

import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/widgets/app_logo_and_name.dart";
import "package:flutter/material.dart";

class PasswordResetHeader extends StatelessWidget {
  final int currentStep;
  final String title;
  final String subtitle;

  static const List<String> _stepLabels = [
    "البريد الإلكتروني",
    "رمز التحقق",
    "كلمة المرور الجديدة",
  ];

  const PasswordResetHeader({
    super.key,
    required this.currentStep,
    required this.title,
    required this.subtitle,
  }) : assert(currentStep >= 0 && currentStep <= 2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLogoAndName(subtitle: "استعادة كلمة المرور"),
        const SizedBox(height: AppSizes.s24),
        _ResetStepper(currentStep: currentStep, labels: _stepLabels),
        const SizedBox(height: AppSizes.s32),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSizes.s4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.foregroundMuted,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _ResetStepper extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const _ResetStepper({required this.currentStep, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "الخطوة ${currentStep + 1} من ${labels.length}",
      child: Row(
        children: List.generate(labels.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Expanded(child: _connector(index, context));
          }

          final step = index ~/ 2;

          return _StepIndicator(
            step: step,
            label: labels[step],
            state: step < currentStep
                ? _StepState.completed
                : step == currentStep
                ? _StepState.current
                : _StepState.upcoming,
          );
        }),
      ),
    );
  }

  Widget _connector(int index, BuildContext context) {
    final isDone = index ~/ 2 < currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.s6),
      decoration: BoxDecoration(
        color: isDone ? AppColors.primary700 : AppColors.border,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

enum _StepState { upcoming, current, completed }

class _StepIndicator extends StatelessWidget {
  final int step;
  final String label;
  final _StepState state;

  const _StepIndicator({
    required this.step,
    required this.label,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = state != _StepState.upcoming;
    final circleColor = isActive
        ? colorScheme.primary
        : Colors.transparent;
    final contentColor = isActive
        ? colorScheme.onPrimary
        : AppColors.textDisabled;

    return Tooltip(
      message: label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
              border: Border.all(
                color: isActive ? colorScheme.primary : AppColors.borderStrong,
                width: 1.5,
              ),
              boxShadow: state == _StepState.current
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.25),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder:
                    (
                      Widget child,
                      Animation<double> animation,
                    ) => ScaleTransition(scale: animation, child: child),
                child: state == _StepState.completed
                    ? Icon(
                        Icons.check_rounded,
                        key: const ValueKey("done"),
                        size: 20,
                        color: contentColor,
                      )
                    : Text(
                        "${step + 1}",
                        key: ValueKey("num-$step"),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: contentColor,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.s6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: isActive ? AppColors.textPrimary : AppColors.textDisabled,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

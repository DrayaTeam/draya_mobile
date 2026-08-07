import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Widget? icon;
  final double? verticalPadding;
  final double? horizontalPadding;
  final TextStyle? textStyle;
  final Size? size;
  final IconAlignment? iconAlignment;
  final Color? borderColor;
  final Color? foregroundColor;
  final double? radius;

  const AppOutlinedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.verticalPadding,
    this.horizontalPadding,
    this.textStyle,
    this.size,
    this.iconAlignment,
    this.borderColor,
    this.foregroundColor,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: icon,
      onPressed: onPressed == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onPressed!();
            },
      iconAlignment: iconAlignment ?? IconAlignment.end,
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor ?? AppColors.primary700,
        disabledForegroundColor: AppColors.textDisabled,
        side: BorderSide(
          color: borderColor ?? AppColors.primary700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 999),
        ),
        minimumSize: size ?? const Size(double.infinity, 48),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? 10,
          horizontal: horizontalPadding ?? 20,
        ),
      ),
      label: Text(
        label,
        style:
            textStyle ??
            AppTextStyles.button.copyWith(
              color: onPressed == null
                  ? AppColors.textDisabled
                  : foregroundColor ?? AppColors.primary700,
            ),
      ),
    );
  }
}

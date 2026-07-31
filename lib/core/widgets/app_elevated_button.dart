import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppElevatedButton extends StatelessWidget {
  final Function()? onPressed;
  final String label;
  final Widget? icon;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? elevation;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Size? size;
  final IconAlignment? iconAlignment;
  final Color? borderColor;
  final double? radius;

  const AppElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.verticalPadding,
    this.elevation,
    this.backgroundColor,
    this.textStyle,
    this.borderColor,
    this.iconAlignment,
    this.size,
    this.horizontalPadding,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon,
      onPressed: onPressed == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onPressed!();
            },
      iconAlignment: iconAlignment ?? IconAlignment.end,
      style: ElevatedButton.styleFrom(
        enableFeedback: true,
        backgroundColor: backgroundColor ?? AppColors.primary700,
        foregroundColor: AppColors.surface,
        disabledBackgroundColor: AppColors.borderStrong,
        disabledForegroundColor: AppColors.textDisabled,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 999),
          side: BorderSide(
            color: borderColor ?? backgroundColor ?? Colors.transparent,
          ),
        ),
        minimumSize: size ?? const Size(double.infinity, 48),
        elevation: elevation ?? 0,
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
                  : AppColors.surface,
            ),
      ),
    );
  }
}

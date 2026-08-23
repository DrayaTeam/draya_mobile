import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";

class GradesEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const GradesEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: AppSizes.s64 * 1.6,
                  height: AppSizes.s64 * 1.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary50,
                    border: Border.all(
                      color: AppColors.primary100,
                      width: AppSizes.s4,
                    ),
                  ),
                ),
                Container(
                  width: AppSizes.s56,
                  height: AppSizes.s56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [AppColors.primary500, AppColors.primary300],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary500.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: AppSizes.s24),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s20),
            Text(title, style: AppTextStyles.h4),
            const SizedBox(height: AppSizes.s8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

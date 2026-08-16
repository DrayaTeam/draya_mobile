import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class MaterialsHeader extends StatelessWidget {
  final int materialCount;

  const MaterialsHeader({super.key, required this.materialCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary700, AppColors.primary500],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppSizes.s20),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.s56,
            height: AppSizes.s56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppSizes.s16),
            ),
            child: const Icon(Icons.folder_copy_outlined, color: Colors.white),
          ),
          const SizedBox(width: AppSizes.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مواد الفصول المسجّل بها',
                  style: AppTextStyles.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.s4),
                Text(
                  materialCount == 0
                      ? 'ستظهر مواد معلّميك هنا'
                      : '$materialCount مادة متاحة لك',
                  style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

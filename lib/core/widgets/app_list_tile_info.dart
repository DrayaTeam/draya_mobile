import "package:draya_mobile/core/helpers/app_extensions.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:flutter/material.dart";

class AppListTileInfo extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const AppListTileInfo({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s12),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary200,
          width: AppSizes.s1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.s12),
      ),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        leading: Container(
          width: AppSizes.s56,
          height: AppSizes.s56,
          decoration: BoxDecoration(
            color: AppColors.primary200,
            borderRadius: BorderRadius.circular(AppSizes.s20),
          ),
          child: Icon(
            icon,
            size: AppSizes.s32,
          ),
        ),
        title: Text(
          title,
          style: context.textTheme.titleLarge,
        ),
        onTap: onTap,
      ),
    );
  }
}

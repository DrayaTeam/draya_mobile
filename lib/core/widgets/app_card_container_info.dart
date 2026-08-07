import 'package:draya_mobile/core/helpers/app_extensions.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/widgets/app_card_container_empty.dart';
import 'package:flutter/material.dart';

class AppCardContainerInfo extends StatelessWidget {
  final String? label;
  final IconData icon;
  final String title;
  final String subtitle;

  const AppCardContainerInfo({
    super.key,
    this.label,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardContainerEmpty(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
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
            label != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary200,
                      borderRadius: BorderRadius.circular(AppSizes.s20),
                    ),
                    child: Text(label!),
                  )
                : const SizedBox.shrink(),
          ],
        ),

        const SizedBox(height: AppSizes.s12),

        Text(
          title,
          style: context.textTheme.displaySmall,
        ),

        Text(subtitle, style: context.textTheme.bodyLarge),
      ],
    );
  }
}

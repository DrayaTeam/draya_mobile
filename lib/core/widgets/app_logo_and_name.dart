import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/widgets/app_logo.dart";
import "package:flutter/material.dart";

class AppLogoAndName extends StatelessWidget {
  final String? subtitle;
  const AppLogoAndName({super.key, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppLogo(),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "درايَة",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              subtitle ?? "نظام التقييم الذكي للمستقبل",
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(
                    color: AppColors.foregroundMuted,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:draya_mobile/core/helpers/assets_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        gradient: const LinearGradient(
          colors: [AppColors.primary700, AppColors.primary600],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary600.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: SvgPicture.asset(
          AppSvgs.logo,
          width: 22,
          height: 22,
        ),
      ),
    );
  }
}

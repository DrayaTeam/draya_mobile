import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

class ReportLoadingPlaceholder extends StatelessWidget {
  const ReportLoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundMuted,
      highlightColor: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _box(height: 110, radius: 20),
          const SizedBox(height: AppSizes.s12),
          Row(
            children: [
              Expanded(child: _box(height: 64, radius: 16)),
              const SizedBox(width: AppSizes.s10),
              Expanded(child: _box(height: 64, radius: 16)),
            ],
          ),
          const SizedBox(height: AppSizes.s12),
          _box(height: 190, radius: 18),
          const SizedBox(height: AppSizes.s12),
          _box(height: 90, radius: 16),
        ],
      ),
    );
  }

  Widget _box({required double height, required double radius}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.backgroundMuted,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

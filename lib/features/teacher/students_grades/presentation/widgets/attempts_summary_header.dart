import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";

class AttemptsSummaryHeader extends StatelessWidget {
  final int totalCount;
  final String examTitle;
  final double? averageScore;

  const AttemptsSummaryHeader({
    super.key,
    required this.totalCount,
    required this.examTitle,
    this.averageScore,
  });

  String get _formattedAverage {
    if (averageScore == null) return "--";
    if (averageScore! % 1 == 0) return averageScore!.toInt().toString();
    return averageScore!.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF145A53), Color(0xFF2D9B8A)],
        ),
        borderRadius: BorderRadius.circular(AppSizes.s16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary800.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -AppSizes.s24,
            left: -AppSizes.s16,
            child: Container(
              width: AppSizes.s56 * 1.5,
              height: AppSizes.s56 * 1.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "نتائج الطلاب",
                      style: AppTextStyles.h5.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      examTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.label.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              _StatPill(
                icon: Icons.groups_rounded,
                label: "$totalCount طالب",
              ),
              const SizedBox(width: AppSizes.s8),
              _StatPill(
                icon: Icons.insights_rounded,
                label: "متوسط $_formattedAverage",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s10,
        vertical: AppSizes.s8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.s6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: AppSizes.s16),
          const SizedBox(height: AppSizes.s4),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              fontSize: 11,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";

class GradesAccentPalette {
  static const List<Color> accents = [
    AppColors.primary500,
    AppColors.mathPhysics,
    AppColors.ai700,
    AppColors.humanities,
    AppColors.cyan,
    AppColors.chemistryBiology,
  ];

  static Color forIndex(int index) => accents[index % accents.length];
}

class ExamGradeCard extends StatelessWidget {
  final String topic;
  final String sectionTitle;
  final int questionsCount;
  final int? durationMinutes;
  final int? allowedAttempts;
  final Color accent;
  final VoidCallback onTap;

  const ExamGradeCard({
    super.key,
    required this.topic,
    required this.sectionTitle,
    required this.questionsCount,
    this.durationMinutes,
    this.allowedAttempts,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.s16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.s16),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.s14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.s16),
            border: Border.all(color: accent.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSizes.s40,
                height: AppSizes.s40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [accent, accent.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Colors.white,
                  size: AppSizes.s20,
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.h5.copyWith(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s10),
                    Wrap(
                      spacing: AppSizes.s6,
                      runSpacing: AppSizes.s6,
                      children: [
                        _MetaChip(
                          icon: Icons.help_outline_rounded,
                          label: "$questionsCount سؤال",
                          color: AppColors.mathPhysics,
                        ),
                        if (durationMinutes != null)
                          _MetaChip(
                            icon: Icons.timer_outlined,
                            label: "$durationMinutes دقيقة",
                            color: AppColors.cyan,
                          ),
                        if (allowedAttempts != null)
                          _MetaChip(
                            icon: Icons.replay_outlined,
                            label: "$allowedAttempts محاولات",
                            color: AppColors.ai700,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.s8),
              Container(
                width: AppSizes.s32,
                height: AppSizes.s32,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: AppSizes.s12,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s8,
        vertical: AppSizes.s4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSizes.s6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.s12, color: color),
          const SizedBox(width: AppSizes.s4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label.copyWith(fontSize: 11, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

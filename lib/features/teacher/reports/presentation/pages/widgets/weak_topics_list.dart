import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/reports/data/models/weak_topics_model.dart";
import "package:flutter/material.dart";

class WeakTopicsList extends StatelessWidget {
  final List<WeakTopicsModel> topics;

  const WeakTopicsList({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: topics
          .map((topic) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _WeakTopicTile(topic: topic),
              ))
          .toList(),
    );
  }
}

class _WeakTopicTile extends StatelessWidget {
  final WeakTopicsModel topic;

  const _WeakTopicTile({required this.topic});

  Color get _levelColor {
    if (topic.proficiencyPercent < 40) return AppColors.error;
    if (topic.proficiencyPercent < 70) return AppColors.amber;
    return AppColors.primary600;
  }

  IconData get _levelIcon {
    if (topic.proficiencyPercent < 40) {
      return Icons.priority_high_rounded;
    }
    if (topic.proficiencyPercent < 70) {
      return Icons.trending_down_rounded;
    }
    return Icons.check_circle_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _levelColor;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: levelColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(_levelIcon, color: levelColor, size: 17),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  topic.topicName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h5.copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                "${topic.proficiencyPercent.toStringAsFixed(0)}%",
                style: AppTextStyles.label.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: levelColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: topic.proficiencyPercent.clamp(0, 100).toDouble() / 100,
              ),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 7,
                backgroundColor: levelColor.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(levelColor),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.tips_and_updates_outlined,
                size: 15,
                color: AppColors.amber,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  topic.recommendation,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 12.5,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

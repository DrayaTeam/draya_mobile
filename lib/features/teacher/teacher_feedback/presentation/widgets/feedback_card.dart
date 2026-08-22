import "package:cached_network_image/cached_network_image.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/domain/entity/classroom_feedback.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/presentation/widgets/star_rating_display.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class FeedbackCard extends StatelessWidget {
  final ClassroomFeedback feedback;

  const FeedbackCard({super.key, required this.feedback});

  String get _initials {
    final parts = feedback.studentName.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty || parts.first.isEmpty) return "?";
    return parts.first.characters.first;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("d MMM yyyy", "ar");
    final formattedDate = dateFormat.format(feedback.createdAt);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: feedback.studentAvatarUrl != null &&
                          feedback.studentAvatarUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: feedback.studentAvatarUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => _AvatarFallback(
                            initials: _initials,
                          ),
                        )
                      : _AvatarFallback(initials: _initials),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback.studentName,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: AppColors.textDisabled,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.textDisabled,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                StarRatingDisplay(rating: feedback.rating),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                feedback.comment,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final String initials;

  const _AvatarFallback({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      color: AppColors.primary100,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTextStyles.h5.copyWith(
          color: AppColors.primary700,
          fontWeight: FontWeight.w800,
          fontSize: 15,
        ),
      ),
    );
  }
}

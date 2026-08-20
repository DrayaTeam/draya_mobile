import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";
import "package:draya_mobile/features/teacher/teacher_channel/domain/entity/question_entity.dart";
import "package:intl/intl.dart";

class QuestionCardWidget extends StatelessWidget {
  final QuestionEntity question;
  final VoidCallback onTap;
  final VoidCallback onVote;
  final bool isVoting;

  const QuestionCardWidget({
    super.key,
    required this.question,
    required this.onTap,
    required this.onVote,
    this.isVoting = false,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("d MMMM، HH:mm", "ar");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: question.hasTeacherAnswer
              ? AppColors.primary300.withValues(alpha: 0.7)
              : AppColors.border,
          width: question.hasTeacherAnswer ? 1.2 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
          if (question.hasTeacherAnswer)
            BoxShadow(
              color: AppColors.primary500.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with metadata and badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: question.isAuthor
                                  ? [AppColors.primary600, AppColors.primary400]
                                  : [
                                      AppColors.backgroundMuted,
                                      AppColors.borderStrong,
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            question.isAuthor
                                ? Icons.person_rounded
                                : Icons.account_circle_outlined,
                            size: 20,
                            color: question.isAuthor
                                ? Colors.white
                                : AppColors.foregroundMuted,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  dateFormat.format(question.createdAt),
                                  style: AppTextStyles.label.copyWith(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (question.isAuthor) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary50,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: AppColors.primary200,
                                      ),
                                    ),
                                    child: Text(
                                      "سؤالي",
                                      style: AppTextStyles.label.copyWith(
                                        fontSize: 10,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (question.hasTeacherAnswer)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "إجابة المدرس",
                              style: AppTextStyles.label.copyWith(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Question content
                Text(
                  question.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),

                // Bottom actions row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Interactive Vote Pill
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: isVoting ? null : onVote,
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: question.hasVoted
                                    ? AppColors.primary50
                                    : AppColors.backgroundSecondary,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: question.hasVoted
                                      ? AppColors.primary300
                                      : AppColors.border,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isVoting)
                                    const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppColors.primary,
                                            ),
                                      ),
                                    )
                                  else
                                    Icon(
                                      question.hasVoted
                                          ? Icons.thumb_up_rounded
                                          : Icons.thumb_up_alt_outlined,
                                      size: 16,
                                      color: question.hasVoted
                                          ? AppColors.primary
                                          : AppColors.foregroundMuted,
                                    ),
                                  const SizedBox(width: 6),
                                  Text(
                                    question.voteCount.toString(),
                                    style: AppTextStyles.label.copyWith(
                                      fontSize: 13,
                                      fontWeight: question.hasVoted
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                      color: question.hasVoted
                                          ? AppColors.primary
                                          : AppColors.foregroundMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Reply Count Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 15,
                                color: AppColors.foregroundMuted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                question.replyCount.toString(),
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.foregroundMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Arrow Icon
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.textDisabled,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

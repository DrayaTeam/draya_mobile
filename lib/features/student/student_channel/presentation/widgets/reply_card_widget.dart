import 'package:flutter/material.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/features/student/student_channel/domain/entity/reply_entity.dart';
import 'package:intl/intl.dart';

class ReplyCardWidget extends StatelessWidget {
  final ReplyEntity reply;

  const ReplyCardWidget({
    super.key,
    required this.reply,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMMM، HH:mm', 'ar');
    final isTeacher = reply.isTeacherAnswer;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isTeacher ? AppColors.primary50 : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTeacher ? AppColors.primary300 : AppColors.border,
          width: isTeacher ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isTeacher ? 0.04 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isTeacher
                              ? [AppColors.primary700, AppColors.primary500]
                              : reply.isAuthor
                                  ? [AppColors.primary600, AppColors.primary400]
                                  : [AppColors.backgroundMuted, AppColors.borderStrong],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isTeacher
                            ? Icons.school_rounded
                            : reply.isAuthor
                                ? Icons.person_rounded
                                : Icons.account_circle_outlined,
                        size: 18,
                        color: isTeacher || reply.isAuthor
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
                              isTeacher ? 'المدرس' : (reply.isAuthor ? 'أنت' : 'طالب'),
                              style: AppTextStyles.label.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isTeacher
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '•  ${dateFormat.format(reply.createdAt)}',
                              style: AppTextStyles.label.copyWith(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                if (isTeacher)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'إجابة معتمدة',
                          style: AppTextStyles.label.copyWith(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Reply Content
            Padding(
              padding: const EdgeInsets.only(right: 42),
              child: Text(
                reply.content,
                style: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  height: 1.55,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


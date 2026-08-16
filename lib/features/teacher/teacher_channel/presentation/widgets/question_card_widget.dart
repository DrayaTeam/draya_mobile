import 'package:flutter/material.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/domain/entity/question_entity.dart';
import 'package:intl/intl.dart';

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
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, HH:mm', 'ar');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateFormat.format(question.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        if (question.hasTeacherAnswer)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'إجابة رسمية',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Semantics(
                    label: 'إجراءات السؤال',
                    button: true,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: isVoting ? null : onVote,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.thumb_up_outlined,
                                  size: 18,
                                  color: question.hasVoted
                                      ? theme.colorScheme.primary
                                      : Colors.grey[600],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  question.voteCount.toString(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: question.hasVoted
                                        ? theme.colorScheme.primary
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              question.replyCount.toString(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

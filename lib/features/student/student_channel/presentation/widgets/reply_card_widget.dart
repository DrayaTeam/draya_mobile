import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, HH:mm', 'ar');
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: reply.isTeacherAnswer
            ? theme.colorScheme.primary.withValues(alpha: 0.05)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: reply.isTeacherAnswer
              ? theme.colorScheme.primary.withValues(alpha: 0.2)
              : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (reply.isTeacherAnswer)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'إجابة المدرس',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    Text(
                      dateFormat.format(reply.createdAt),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Text(
            reply.content,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

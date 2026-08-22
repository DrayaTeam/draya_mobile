import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/notifications/domain/entity/app_notification.dart";
import "package:flutter/material.dart";

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  IconData get _icon {
    switch (notification.type) {
      case AppNotificationType.examGeneration:
        return Icons.quiz_outlined;
      case AppNotificationType.reportGenerated:
        return Icons.assessment_outlined;
      case AppNotificationType.studentAtRisk:
        return Icons.warning_amber_rounded;
    }
  }

  Color get _accentColor {
    switch (notification.type) {
      case AppNotificationType.examGeneration:
        return AppColors.ai700;
      case AppNotificationType.reportGenerated:
        return AppColors.primary600;
      case AppNotificationType.studentAtRisk:
        return AppColors.error;
    }
  }

  String _formatRelativeTime(DateTime createdAt) {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inSeconds < 60) return "الآن";
    if (difference.inMinutes < 60) return "قبل ${difference.inMinutes} دقيقة";
    if (difference.inHours < 24) return "قبل ${difference.inHours} ساعة";
    if (difference.inDays == 1) return "أمس";
    if (difference.inDays < 7) return "قبل ${difference.inDays} أيام";
    return "${createdAt.day}/${createdAt.month}/${createdAt.year}";
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor;

    return Dismissible(
      key: ValueKey<String>("dismiss-${notification.id}"),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSizes.s16),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color:
              notification.isRead
              ? AppColors.surface
              : AppColors.backgroundAccent,
          borderRadius: BorderRadius.circular(AppSizes.s16),
          border: Border.all(
            color:
                notification.isRead
                ? AppColors.border
                : accent.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSizes.s16),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accent,
                              Color.lerp(accent, Colors.white, 0.25)!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppSizes.s12),
                        ),
                        child: Icon(_icon, color: Colors.white, size: 22),
                      ),
                      if (!notification.isRead)
                        PositionedDirectional(
                          top: 0,
                          end: 0,
                          child: Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    notification.isRead
                                    ? AppColors.border
                                    : AppColors.backgroundAccent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: AppSizes.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 14,
                                  fontWeight:
                                      notification.isRead
                                      ? FontWeight.w500
                                      : FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              _formatRelativeTime(notification.createdAt),
                              style: AppTextStyles.label.copyWith(
                                fontSize: 11,
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.s4),
                        Text(
                          notification.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12.5,
                            height: 1.6,
                            color:
                                notification.isRead
                                ? AppColors.textSecondary
                                : AppColors.foregroundMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

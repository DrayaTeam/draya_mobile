import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class MaterialsEmptyState extends StatelessWidget {
  final VoidCallback onRefresh;
  const MaterialsEmptyState({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) => _FeedbackContent(
        icon: Icons.folder_open_rounded,
        title: 'لا توجد مواد متاحة بعد',
        message: 'عندما يضيف معلّموك مواداً إلى الفصول المسجّل بها، ستظهر هنا.',
        actionLabel: 'تحديث القائمة',
        onAction: onRefresh,
      );
}

class MaterialsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const MaterialsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) => _FeedbackContent(
        icon: Icons.error_outline_rounded,
        iconColor: AppColors.error,
        title: 'تعذّر تحميل المواد',
        message: message,
        actionLabel: 'إعادة المحاولة',
        onAction: onRetry,
      );
}

class _FeedbackContent extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _FeedbackContent({
    required this.icon,
    this.iconColor = AppColors.primary,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Icon(icon, size: 38, color: iconColor),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  actionLabel,
                  style: AppTextStyles.button.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
}


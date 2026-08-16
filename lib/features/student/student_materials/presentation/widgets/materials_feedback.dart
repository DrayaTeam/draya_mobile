import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class MaterialsEmptyState extends StatelessWidget {
  final VoidCallback onRefresh;
  const MaterialsEmptyState({super.key, required this.onRefresh});
  @override
  Widget build(BuildContext context) => _FeedbackContent(icon: Icons.folder_open_rounded, title: 'لا توجد مواد متاحة بعد', message: 'عندما يضيف معلّموك مواداً إلى الفصول المسجّل بها، ستظهر هنا.', actionLabel: 'تحديث', onAction: onRefresh);
}

class MaterialsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const MaterialsErrorState({super.key, required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => _FeedbackContent(icon: Icons.error_outline_rounded, iconColor: AppColors.error, title: 'تعذّر تحميل المواد', message: message, actionLabel: 'إعادة المحاولة', onAction: onRetry);
}

class _FeedbackContent extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  const _FeedbackContent({required this.icon, this.iconColor = AppColors.primary700, required this.title, required this.message, required this.actionLabel, required this.onAction});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(AppSizes.s24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(width: 88, height: 88, decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.s20)), child: Icon(icon, size: 44, color: iconColor)), const SizedBox(height: AppSizes.s20), Text(title, textAlign: TextAlign.center, style: AppTextStyles.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(height: AppSizes.s8), Text(message, textAlign: TextAlign.center, style: AppTextStyles.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)), const SizedBox(height: AppSizes.s20), FilledButton.icon(onPressed: onAction, icon: const Icon(Icons.refresh_rounded), label: Text(actionLabel))])));
}

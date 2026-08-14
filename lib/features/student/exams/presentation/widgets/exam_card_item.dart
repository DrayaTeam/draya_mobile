import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../models/exam_item.dart';

class ExamCardItem extends StatelessWidget {
  final ExamItem exam;
  final VoidCallback? onActionTap;

  const ExamCardItem({
    super.key,
    required this.exam,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSubjectChip(
                  exam.subject,
                  exam.subjectAccentColor,
                  exam.subjectTextColor,
                ),
                _buildStatusChip(exam.statusLabel, exam.statusColor),
              ],
            ),
            const SizedBox(height: AppSizes.s16),
            Text(
              exam.title,
              textAlign: TextAlign.right,
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSizes.s4),
            Text(
              'المعلم: ${exam.teacher}',
              textAlign: TextAlign.right,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSizes.s16),
            Container(
              padding: const EdgeInsets.all(AppSizes.s16),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildInfoColumn(
                      'مدة الامتحان',
                      exam.duration,
                      AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSizes.s12),
                  Expanded(
                    child: _buildInfoColumn(
                      'التفاصيل',
                      exam.extraLabel,
                      exam.extraColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.s16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: exam.actionEnabled ? () {
                  onActionTap?.call();
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: exam.actionEnabled
                      ? exam.actionColor
                      : AppColors.backgroundMuted,
                  foregroundColor: exam.actionEnabled
                      ? AppColors.surface
                      : AppColors.textSecondary,   
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.s12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 0,          
                ),
                icon: exam.actionEnabled ? const Icon(Icons.arrow_forward) : null,
                iconAlignment: IconAlignment.end,
                label: Text(
                  exam.actionLabel,
                  style: AppTextStyles.label.copyWith(
                    color: exam.actionEnabled
                        ? AppColors.surface
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectChip(String label, Color background, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s16,
        vertical: AppSizes.s8,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: textColor,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s12,
        vertical: AppSizes.s8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: AppSizes.s4),
        Text(
          value,
          style: AppTextStyles.label.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w900,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class StudentHomeAlertsSection extends StatelessWidget {
  const StudentHomeAlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          border: Border.all(
            color: const Color(0xFFFFCCD3).withValues(alpha: 0.8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 1),
              blurRadius: 2,
              spreadRadius: -1,
            ),
          ],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تنبيهات ومواعيد عاجلة',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4E6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Center(
                    child: Text(
                      'تنبيهان جديدان',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s16),
            const _AlertItem(
              accentColor: Color(0xFFEC003F),
              iconColor: Color(0xFFEC003F),
              title: 'امتحان الباب الثالث (جبر)',
              subtitle: 'غداً 10:00 ص',
              badgeText: 'هام',
              badgeColor: Color(0xFFFFFFFF),
              badgeBorderColor: Color(0xFFE2E8F0),
            ),
            const SizedBox(height: AppSizes.s8),
            const _AlertItem(
              accentColor: Color(0xFFFE9A00),
              iconColor: Color(0xFFFE9A00),
              title: 'مراجعة قانون كيرشوف (فيزياء)',
              subtitle: 'الخميس 11:00 ص',
              badgeText: 'مراجعة',
              badgeColor: Color(0xFFFFFFFF),
              badgeBorderColor: Color(0xFFE2E8F0),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final Color accentColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final Color badgeBorderColor;

  const _AlertItem({
    required this.accentColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              border: Border.all(color: badgeBorderColor),
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.center,
            child: Text(
              badgeText,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF45556C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

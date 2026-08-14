import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class TeacherCardItem extends StatelessWidget {
  final String fullName;
  final String email;
  final String phone;
  final String specialization;
  final VoidCallback? onViewClassrooms;

  const TeacherCardItem({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.specialization,
    this.onViewClassrooms,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _buildInitials(fullName);

    return Semantics(
      label: 'بطاقة المعلم $fullName، تخصص $specialization',
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.s16),
        padding: const EdgeInsets.all(AppSizes.s16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.s20),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(17, 24, 39, 0.04),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(AppSizes.s16),
                  ),
                  child: Text(
                    initials,
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.primary700,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSizes.s4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.s8,
                          vertical: AppSizes.s4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.primary100,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          specialization,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.primary700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s16),
            Column(
              children: [
                _buildInfoRow(
                  icon: Icons.email_outlined,
                  label: email.isEmpty ? 'N/A' : email,
                ),
                const SizedBox(height: AppSizes.s8),
                _buildInfoRow(
                  icon: Icons.phone_outlined,
                  label: phone,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onViewClassrooms,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.s12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.s12),
                  ),
                ),
                icon: const Icon(Icons.school_outlined, size: 18),
                label: const Text('عرض الفصول'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildInitials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s12,
        vertical: AppSizes.s8,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundMuted,
        borderRadius: BorderRadius.circular(AppSizes.s12),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: BorderRadius.circular(AppSizes.s8),
            ),
            child: Icon(icon, size: 16, color: AppColors.primary700),
          ),
          const SizedBox(width: AppSizes.s8),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";

class TeacherWalletActionsRow extends StatelessWidget {
  final VoidCallback onWithdraw;
  final VoidCallback onAddPayoutAccount;
  final VoidCallback? onScrollToHistory;

  const TeacherWalletActionsRow({
    super.key,
    required this.onWithdraw,
    required this.onAddPayoutAccount,
    this.onScrollToHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Primary action: Request Withdrawal
        Expanded(
          flex: 3,
          child: _buildActionButton(
            context,
            icon: Icons.arrow_outward_rounded,
            label: "طلب سحب رصيد",
            isPrimary: true,
            onTap: onWithdraw,
          ),
        ),
        const SizedBox(width: AppSizes.s12),
        // Secondary action: Add Payout Account
        Expanded(
          flex: 3,
          child: _buildActionButton(
            context,
            icon: Icons.account_balance_outlined,
            label: "حسابات السحب",
            isPrimary: false,
            onTap: onAddPayoutAccount,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.s12 + 2,
            horizontal: AppSizes.s12,
          ),
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.primary700 : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPrimary ? AppColors.primary800 : AppColors.border,
              width: 1.2,
            ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.primary700.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.s6),
                decoration: BoxDecoration(
                  color: isPrimary
                      ? Colors.white.withValues(alpha: 0.15)
                      : AppColors.primary100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isPrimary ? Colors.white : AppColors.primary700,
                ),
              ),
              const SizedBox(width: AppSizes.s8),
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.label.copyWith(
                    color: isPrimary ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

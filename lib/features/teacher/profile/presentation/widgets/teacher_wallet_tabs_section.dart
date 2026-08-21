import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/app_custom_loading.dart";
import "package:draya_mobile/features/teacher/profile/presentation/widgets/payout_account_bottom_sheet.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/transaction_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_model.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/payout_accounts_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/payout_accounts_state.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/transactions_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/transactions_state.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/withdrawals_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/withdrawals_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TeacherWalletTabsSection extends StatefulWidget {
  final VoidCallback? onRequestWithdrawal;

  const TeacherWalletTabsSection({
    super.key,
    this.onRequestWithdrawal,
  });

  @override
  State<TeacherWalletTabsSection> createState() =>
      _TeacherWalletTabsSectionState();
}

class _TeacherWalletTabsSectionState extends State<TeacherWalletTabsSection> {
  int _selectedTabIndex = 0; // 0: Transactions, 1: Withdrawals, 2: Payout Accounts

  @override
  void initState() {
    super.initState();
    _loadTabData(_selectedTabIndex);
  }

  void _loadTabData(int index) {
    if (index == 0) {
      context.read<TransactionsCubit>().getTransactions();
    } else if (index == 1) {
      context.read<WithdrawalsCubit>().getWithdrawals();
    } else if (index == 2) {
      context.read<PayoutAccountsCubit>().getPayoutAccounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Segmented Navigation Header
          _buildSegmentedHeader(),

          const SizedBox(height: AppSizes.s16),

          // Tab Content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _buildCurrentTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedHeader() {
    final tabs = [
      {"icon": Icons.receipt_long_rounded, "label": "المعاملات"},
      {"icon": Icons.history_rounded, "label": "طلبات السحب"},
      {"icon": Icons.account_balance_outlined, "label": "حسابات السحب"},
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.backgroundMuted,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          final tab = tabs[index];

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (_selectedTabIndex != index) {
                  setState(() => _selectedTabIndex = index);
                  _loadTabData(index);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab["icon"] as IconData,
                      size: 16,
                      color: isSelected
                          ? AppColors.primary700
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tab["label"] as String,
                      style: AppTextStyles.label.copyWith(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary800
                            : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildTransactionsTab();
      case 1:
        return _buildWithdrawalsTab();
      case 2:
        return _buildPayoutAccountsTab();
      default:
        return const SizedBox.shrink();
    }
  }

  // ==================== TAB 1: TRANSACTIONS ====================

  Widget _buildTransactionsTab() {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      key: const ValueKey("transactions_tab"),
      builder: (context, state) {
        if (state.status == CubitStatus.loading &&
            state.transactionsResult == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: AppCustomLoading()),
          );
        }

        if (state.status == CubitStatus.error &&
            state.transactionsResult == null) {
          return _buildErrorPlaceholder(
            message: "تعذر تحميل سجل المعاملات المالية",
            onRetry: () =>
                context.read<TransactionsCubit>().getTransactions(isRefresh: true),
          );
        }

        final items = state.transactionsResult?.items ?? [];

        if (items.isEmpty) {
          return _buildEmptyPlaceholder(
            icon: Icons.receipt_long_outlined,
            title: "لا توجد معاملات مالية حتى الآن",
            subtitle: "ستظهر هنا جميع عمليات الشحن والسحب والأرباح",
          );
        }

        return Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: AppColors.border, height: 16),
              itemBuilder: (context, index) {
                return _buildTransactionItem(items[index]);
              },
            ),
            if (state.transactionsResult?.hasNextPage == true) ...[
              const SizedBox(height: 12),
              Center(
                child: state.isPaginating
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton.icon(
                        onPressed: () => context
                            .read<TransactionsCubit>()
                            .loadMoreTransactions(),
                        icon: const Icon(Icons.expand_more_rounded, size: 18),
                        label: const Text("تحميل المزيد من المعاملات"),
                      ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTransactionItem(TransactionModel tx) {
    return Row(
      children: [
        // Transaction Type Icon
        Container(
          padding: const EdgeInsets.all(AppSizes.s10),
          decoration: BoxDecoration(
            color: tx.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            tx.iconData,
            color: tx.color,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSizes.s12),
        // Description and details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tx.description?.isNotEmpty == true
                    ? tx.description!
                    : tx.typeName,
                style: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    tx.formattedDate,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: const BoxDecoration(
                      color: AppColors.textDisabled,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tx.balanceTypeName,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.s8),
        // Amount Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: tx.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tx.formattedAmount,
            style: AppTextStyles.label.copyWith(
              color: tx.color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== TAB 2: WITHDRAWALS ====================

  Widget _buildWithdrawalsTab() {
    return BlocBuilder<WithdrawalsCubit, WithdrawalsState>(
      key: const ValueKey("withdrawals_tab"),
      builder: (context, state) {
        if (state.status == CubitStatus.loading &&
            state.withdrawalsResult == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: AppCustomLoading()),
          );
        }

        if (state.status == CubitStatus.error &&
            state.withdrawalsResult == null) {
          return _buildErrorPlaceholder(
            message: "تعذر تحميل سجل طلبات السحب",
            onRetry: () =>
                context.read<WithdrawalsCubit>().getWithdrawals(isRefresh: true),
          );
        }

        final items = state.withdrawalsResult?.items ?? [];

        if (items.isEmpty) {
          return _buildEmptyPlaceholder(
            icon: Icons.hourglass_empty_rounded,
            title: "لا توجد طلبات سحب حتى الآن",
            subtitle: "عند طلب سحب رصيدك، ستتمكن من متابعة حالة موافقة الإدارة هنا",
            actionButtonText: "طلب سحب جديد",
            onAction: widget.onRequestWithdrawal,
          );
        }

        return Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildWithdrawalCard(items[index]);
              },
            ),
            if (state.withdrawalsResult?.hasNextPage == true) ...[
              const SizedBox(height: 12),
              Center(
                child: state.isPaginating
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton.icon(
                        onPressed: () => context
                            .read<WithdrawalsCubit>()
                            .loadMoreWithdrawals(),
                        icon: const Icon(Icons.expand_more_rounded, size: 18),
                        label: const Text("تحميل المزيد من طلبات السحب"),
                      ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildWithdrawalCard(WithdrawalModel item) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s14),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.status == 0
              ? const Color(0xFFFDE68A)
              : item.status == 1
                  ? const Color(0xFFBBF7D0)
                  : item.status == 2
                      ? const Color(0xFFFECACA)
                      : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: Amount & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item.statusIcon,
                      color: item.statusColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: AppSizes.s10),
                  Text(
                    item.formattedAmount,
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              // Status Badge Pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: item.statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.statusIcon,
                      size: 13,
                      color: item.statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.statusLabel,
                      style: AppTextStyles.label.copyWith(
                        color: item.statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.s10),

          // Date Requested Row
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                "تاريخ الطلب: ${item.formattedRequestedDate}",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),

          if (item.formattedProcessedDate != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.done_all_rounded,
                  size: 13,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  "تاريخ المعالجة: ${item.formattedProcessedDate}",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ],

          // Admin Note or Rejection Reason if available
          if (item.adminNote?.isNotEmpty == true ||
              item.rejectionReason?.isNotEmpty == true) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(AppSizes.s10),
              decoration: BoxDecoration(
                color: item.status == 2
                    ? const Color(0xFFFEF2F2)
                    : AppColors.backgroundMuted,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: item.status == 2
                      ? const Color(0xFFFCA5A5)
                      : AppColors.borderStrong,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item.status == 2
                        ? Icons.report_problem_outlined
                        : Icons.note_outlined,
                    size: 15,
                    color: item.status == 2
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.rejectionReason?.isNotEmpty == true
                          ? "سبب الرفض: ${item.rejectionReason}"
                          : "ملاحظة الإدارة: ${item.adminNote}",
                      style: AppTextStyles.body.copyWith(
                        fontSize: 11.5,
                        color: item.status == 2
                            ? const Color(0xFF991B1B)
                            : AppColors.textPrimary,
                        fontWeight: item.status == 2
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==================== TAB 3: PAYOUT ACCOUNTS ====================

  Widget _buildPayoutAccountsTab() {
    return BlocBuilder<PayoutAccountsCubit, PayoutAccountsState>(
      key: const ValueKey("payout_accounts_tab"),
      builder: (context, state) {
        if (state.status == CubitStatus.loading && state.accounts.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: AppCustomLoading()),
          );
        }

        if (state.status == CubitStatus.error && state.accounts.isEmpty) {
          return _buildErrorPlaceholder(
            message: "تعذر تحميل حسابات السحب",
            onRetry: () =>
                context.read<PayoutAccountsCubit>().getPayoutAccounts(),
          );
        }

        final accounts = state.accounts;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add New Account button header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "الحسابات المسجلة (${accounts.length})",
                  style: AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final created = await PayoutAccountBottomSheet.show(context);
                    if (created == true && context.mounted) {
                      await context.read<PayoutAccountsCubit>().getPayoutAccounts();
                    }
                  },
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text("إضافة حساب"),
                ),
              ],
            ),

            const SizedBox(height: 8),

            if (accounts.isEmpty)
              _buildEmptyPlaceholder(
                icon: Icons.account_balance_wallet_outlined,
                title: "لم يتم حفظ أي حساب سحب بعد",
                subtitle: "أضف حسابك البنكي أو محفظة كاش أو إنستاباي لتتمكن من استلام أرباحك",
                actionButtonText: "إضافة حساب سحب الآن",
                onAction: () async {
                  final created = await PayoutAccountBottomSheet.show(context);
                  if (created == true && context.mounted) {
                    await context.read<PayoutAccountsCubit>().getPayoutAccounts();
                  }
                },
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: accounts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _buildPayoutAccountCard(accounts[index]);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildPayoutAccountCard(PayoutAccountModel account) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s14),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: account.isDefault
              ? AppColors.primary300
              : AppColors.border,
          width: account.isDefault ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Account Type Icon Box
          Container(
            padding: const EdgeInsets.all(AppSizes.s10),
            decoration: BoxDecoration(
              color: account.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              account.iconData,
              color: account.color,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSizes.s12),
          // Account Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        account.accountName,
                        style: AppTextStyles.label.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (account.isDefault) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "الافتراضي",
                          style: AppTextStyles.label.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "${account.typeName} • ${account.accountIdentifier}",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Actions Menu Popup
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) async {
              if (value == "edit") {
                final updated = await PayoutAccountBottomSheet.show(
                  context,
                  accountToEdit: account,
                );
                if (updated == true && mounted) {
                  await context.read<PayoutAccountsCubit>().getPayoutAccounts();
                }
              } else if (value == "delete") {
                _confirmDeleteAccount(account);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "edit",
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18, color: AppColors.textPrimary),
                    SizedBox(width: 8),
                    Text("تعديل الحساب"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "delete",
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                    SizedBox(width: 8),
                    Text("حذف الحساب", style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(PayoutAccountModel account) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text("تأكيد الحذف"),
          ],
        ),
        content: Text(
          "هل أنت متأكد من رغبتك في حذف حساب '${account.accountName}'؟",
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(dialogCtx).pop();
              await context
                  .read<PayoutAccountsCubit>()
                  .deletePayoutAccount(account.id);
            },
            child: const Text("حذف"),
          ),
        ],
      ),
    );
  }

  // ==================== PLACEHOLDERS ====================

  Widget _buildEmptyPlaceholder({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionButtonText,
    VoidCallback? onAction,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.s14),
            decoration: const BoxDecoration(
              color: AppColors.backgroundMuted,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.textDisabled,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSizes.s12),
          Text(
            title,
            style: AppTextStyles.label.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionButtonText != null && onAction != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add, size: 16),
              label: Text(actionButtonText),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary700,
                side: const BorderSide(color: AppColors.primary700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorPlaceholder({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text("إعادة المحاولة"),
          ),
        ],
      ),
    );
  }
}

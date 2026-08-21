import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/app_label.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/features/teacher/profile/presentation/widgets/payout_account_bottom_sheet.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/payout_accounts_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/payout_accounts_state.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/wallet_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/withdrawals_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/withdrawals_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TeacherWithdrawBottomSheet extends StatefulWidget {
  final double availableBalance;

  const TeacherWithdrawBottomSheet({
    super.key,
    required this.availableBalance,
  });

  static Future<bool?> show(
    BuildContext context, {
    required double availableBalance,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<WithdrawalsCubit>()),
          BlocProvider.value(value: context.read<PayoutAccountsCubit>()),
          BlocProvider.value(value: context.read<WalletCubit>()),
        ],
        child: TeacherWithdrawBottomSheet(
          availableBalance: availableBalance,
        ),
      ),
    );
  }

  @override
  State<TeacherWithdrawBottomSheet> createState() =>
      _TeacherWithdrawBottomSheetState();
}

class _TeacherWithdrawBottomSheetState
    extends State<TeacherWithdrawBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  String? _selectedAccountId;
  String? _amountError;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    context.read<PayoutAccountsCubit>().getPayoutAccounts();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setPercentage(double fraction) {
    final amount = widget.availableBalance * fraction;
    _amountController.text = amount.toStringAsFixed(2);
    setState(() => _amountError = null);
  }

  Future<void> _submitWithdrawal() async {
    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText);

    final accounts = context.read<PayoutAccountsCubit>().state.accounts;
    final selectedAccount = _selectedAccountId == null
        ? null
        : accounts.where((a) => a.id == _selectedAccountId).firstOrNull;

    if (selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text("من فضلك اختر حساب السحب أولاً"),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (amount == null || amount <= 0) {
      setState(() => _amountError = "من فضلك أدخل مبلغ سحب صحيح أكبر من صفر");
      return;
    }

    if (amount > widget.availableBalance) {
      setState(
        () => _amountError = "المبلغ المطلوب أكبر من الرصيد المتاح للسحب",
      );
      return;
    }

    setState(() => _amountError = null);
    FocusScope.of(context).unfocus();

    final request = WithdrawalRequestModel(
      amount: amount,
      payoutAccountId: selectedAccount.id,
    );

    final success = await context.read<WithdrawalsCubit>().createWithdrawal(
      request,
    );

    if (mounted && success) {
      await context.read<WalletCubit>().getTeacherBalance();
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "تم إنشاء طلب السحب بنجاح! الطلب قيد المراجعة من الإدارة.",
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primary700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<WithdrawalsCubit, WithdrawalsState>(
      listenWhen: (previous, current) =>
          previous.apiErrorModel != current.apiErrorModel &&
          current.apiErrorModel != null,
      listener: (context, state) {
        if (state.apiErrorModel != null) {
          AppDialogHelper.display(
            context,
            AppErrorDialog(
              apiErrorModel: state.apiErrorModel!,
              onRetry: _submitWithdrawal,
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          left: AppSizes.s20,
          right: AppSizes.s20,
          top: AppSizes.s16,
          bottom: AppSizes.s24 + bottomInset,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.borderStrong,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.s16),

                // Sheet Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.s10),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.arrow_outward_rounded,
                        color: AppColors.primary700,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppSizes.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "طلب سحب أرباح",
                            style: AppTextStyles.h3.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            "تحويل الرصيد المكتسب المتاح إلى حسابك البنكي أو المحفظة",
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.s16),

                // Available Balance Pill Card
                Container(
                  padding: const EdgeInsets.all(AppSizes.s16),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on_outlined,
                            color: AppColors.primary700,
                            size: 22,
                          ),
                          const SizedBox(width: AppSizes.s8),
                          Text(
                            "الرصيد المتاح للسحب:",
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.primary800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${widget.availableBalance.toStringAsFixed(2)} ج.م",
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primary900,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.s16),

                // Payout Account Selector
                const AppLabel(label: "اختر حساب السحب"),
                const SizedBox(height: AppSizes.s8),
                _buildAccountSelector(),

                const SizedBox(height: AppSizes.s16),

                // Withdrawal Amount
                const AppLabel(label: "مبلغ السحب (ج.م)"),
                const SizedBox(height: AppSizes.s8),
                AppTextFormField(
                  controller: _amountController,
                  hintText: "أدخل المبلغ المراد سحبه",
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  prefixIcon: Icons.attach_money_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "مبلغ السحب مطلوب";
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed <= 0) {
                      return "يجب إدخال رقم صحيح أكبر من صفر";
                    }
                    if (parsed > widget.availableBalance) {
                      return "المبلغ يتجاوز الرصيد المتاح للسحب";
                    }
                    return null;
                  },
                ),

                if (_amountError != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    _amountError!,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],

                const SizedBox(height: AppSizes.s10),

                // Percentage Quick Buttons
                Row(
                  children: [
                    _buildPercentageChip("25%", 0.25),
                    const SizedBox(width: 8),
                    _buildPercentageChip("50%", 0.50),
                    const SizedBox(width: 8),
                    _buildPercentageChip("75%", 0.75),
                    const SizedBox(width: 8),
                    _buildPercentageChip("الكل 100%", 1.0),
                  ],
                ),

                const SizedBox(height: AppSizes.s20),

                // Admin Approval Notice Banner (Highlighted)
                Container(
                  padding: const EdgeInsets.all(AppSizes.s12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB), // Amber 50
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFFDE68A),
                    ), // Amber 200
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.admin_panel_settings_outlined,
                        color: Color(0xFFD97706), // Amber 600
                        size: 22,
                      ),
                      const SizedBox(width: AppSizes.s10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "تتطلب العملية تأكيد الإدارة",
                              style: AppTextStyles.label.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF92400E), // Amber 800
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "يتم فحص ومراجعة طلب السحب من قبل إدارة المنصة وسيتم تحويل الرصيد إلى حسابك المختار بعد الاعتماد مباشرة خلال 24 - 48 ساعة.",
                              style: AppTextStyles.body.copyWith(
                                color: const Color(0xFFB45309), // Amber 700
                                fontSize: 11.5,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.s24),

                // Submit Button
                BlocBuilder<WithdrawalsCubit, WithdrawalsState>(
                  builder: (context, state) {
                    return AppElevatedButton(
                      onPressed:
                          state.isSubmittingWithdrawal ||
                              widget.availableBalance <= 0
                          ? null
                          : _submitWithdrawal,
                      //isLoading: state.isSubmittingWithdrawal,
                      label: widget.availableBalance <= 0
                          ? "لا يوجد رصيد متاح للسحب"
                          : "تأكيد وإرسال طلب السحب",
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 18,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPercentageChip(String label, double fraction) {
    // final amount = widget.availableBalance * fraction;
    final isZero = widget.availableBalance <= 0;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isZero ? null : () => _setPercentage(fraction),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.backgroundMuted,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.label.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isZero ? AppColors.textDisabled : AppColors.primary700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSelector() {
    return BlocBuilder<PayoutAccountsCubit, PayoutAccountsState>(
      builder: (context, state) {
        if (state.status == CubitStatus.loading && state.accounts.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(AppSizes.s16),
            decoration: BoxDecoration(
              color: AppColors.backgroundMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (state.accounts.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(AppSizes.s14),
            decoration: BoxDecoration(
              color: AppColors.backgroundMuted,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.amber,
                  size: 20,
                ),
                const SizedBox(width: AppSizes.s8),
                Expanded(
                  child: Text(
                    "لم تقم بإضافة حساب سحب حتى الآن",
                    style: AppTextStyles.body.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final created = await PayoutAccountBottomSheet.show(
                      context,
                    );
                    if (created == true && context.mounted) {
                      await context
                          .read<PayoutAccountsCubit>()
                          .getPayoutAccounts();
                    }
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("إضافة حساب"),
                ),
              ],
            ),
          );
        }

        // Set default account if not yet selected
        if (_selectedAccountId == null) {
          final defaultAcc = state.accounts.firstWhere(
            (a) => a.isDefault,
            orElse: () => state.accounts.first,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _selectedAccountId == null) {
              setState(() => _selectedAccountId = defaultAcc.id);
            }
          });
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.s12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderStrong),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedAccountId,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: state.accounts.map((account) {
                return DropdownMenuItem<String>(
                  value: account.id,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSizes.s6),
                        decoration: BoxDecoration(
                          color: account.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          account.iconData,
                          size: 16,
                          color: account.color,
                        ),
                      ),
                      const SizedBox(width: AppSizes.s10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  account.accountName,
                                  style: AppTextStyles.label.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                  ),
                                ),
                                if (account.isDefault) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.amber.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "افتراضي",
                                      style: AppTextStyles.label.copyWith(
                                        fontSize: 9,
                                        color: const Color(0xFFB45309),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              "${account.typeName} - ${account.accountIdentifier}",
                              style: AppTextStyles.body.copyWith(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (id) {
                if (id != null) {
                  setState(() => _selectedAccountId = id);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

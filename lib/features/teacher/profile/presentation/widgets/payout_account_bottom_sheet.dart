import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_label.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/payout_accounts_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/payout_accounts_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PayoutAccountBottomSheet extends StatefulWidget {
  final PayoutAccountModel? accountToEdit;

  const PayoutAccountBottomSheet({
    super.key,
    this.accountToEdit,
  });

  static Future<bool?> show(
    BuildContext context, {
    PayoutAccountModel? accountToEdit,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: context.read<PayoutAccountsCubit>(),
        child: PayoutAccountBottomSheet(accountToEdit: accountToEdit),
      ),
    );
  }

  @override
  State<PayoutAccountBottomSheet> createState() =>
      _PayoutAccountBottomSheetState();
}

class _PayoutAccountBottomSheetState extends State<PayoutAccountBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _identifierController;
  late PayoutAccountType _selectedType;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final edit = widget.accountToEdit;
    _nameController = TextEditingController(text: edit?.accountName ?? "");
    _identifierController =
        TextEditingController(text: edit?.accountIdentifier ?? "");
    _selectedType = edit?.typeEnum ?? PayoutAccountType.instaPay;
    _isDefault = edit?.isDefault ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final request = PayoutAccountRequestModel(
      accountType: _selectedType.value,
      accountName: _nameController.text.trim(),
      accountIdentifier: _identifierController.text.trim(),
      isDefault: _isDefault,
    );

    final cubit = context.read<PayoutAccountsCubit>();
    bool success;
    if (widget.accountToEdit != null) {
      success = await cubit.updatePayoutAccount(
        widget.accountToEdit!.id,
        request,
      );
    } else {
      success = await cubit.createPayoutAccount(request);
    }

    if (mounted && success) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.accountToEdit != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
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

              // Title Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.s10),
                    decoration: BoxDecoration(
                      color: AppColors.primary100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      isEditing
                          ? Icons.edit_note_rounded
                          : Icons.account_balance_wallet_rounded,
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
                          isEditing ? "تعديل حساب السحب" : "إضافة حساب سحب جديد",
                          style: AppTextStyles.h3.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          "أدخل بيانات الحساب لتتمكن من استلام أرباحك",
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

              const SizedBox(height: AppSizes.s20),

              // Account Type Selector
              const AppLabel(label: "نوع الحساب المالي"),
              const SizedBox(height: AppSizes.s8),
              _buildTypeSelector(),

              const SizedBox(height: AppSizes.s16),

              // Account Name
              const AppLabel(label: "اسم صاحب الحساب"),
              const SizedBox(height: AppSizes.s8),
              AppTextFormField(
                controller: _nameController,
                hintText: "أدخل الاسم كما هو مسجل في الحساب",
                prefixIcon: Icons.badge_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "اسم صاحب الحساب مطلوب";
                  }
                  if (value.trim().length < 3) {
                    return "يجب أن يكون الاسم 3 أحرف على الأقل";
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSizes.s16),

              // Account Identifier
              AppLabel(label: _selectedType.identifierHint),
              const SizedBox(height: AppSizes.s8),
              AppTextFormField(
                controller: _identifierController,
                hintText: _selectedType == PayoutAccountType.bankAccount
                    ? "EG000000000000000000000000000"
                    : _selectedType == PayoutAccountType.instaPay
                        ? "username@instapay / 010xxxxxxxx"
                        : "010xxxxxxxx / 011xxxxxxxx",
                prefixIcon: _selectedType.icon,
                keyboardType: _selectedType == PayoutAccountType.bankAccount
                    ? TextInputType.text
                    : TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "المعرف المالي مطلوب";
                  }
                  if (_selectedType == PayoutAccountType.vodafoneCash) {
                    final clean = value.replaceAll(" ", "");
                    if (!RegExp(r"^01[0125][0-9]{8}$").hasMatch(clean)) {
                      return "من فضلك أدخل رقم هاتف صحيح للمحفظة";
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSizes.s16),

              // Set as Default switch
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s16,
                  vertical: AppSizes.s10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundMuted,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.amber,
                          size: 22,
                        ),
                        const SizedBox(width: AppSizes.s10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "تعيين كحساب سحب افتراضي",
                              style: AppTextStyles.label.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              "سيتم اختياره تلقائياً عند طلب السحب",
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: _isDefault,
                      activeThumbColor: AppColors.primary700,
                      onChanged: (val) {
                        setState(() => _isDefault = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.s24),

              // Submit Button
              BlocBuilder<PayoutAccountsCubit, PayoutAccountsState>(
                builder: (context, state) {
                  return AppElevatedButton(
                    onPressed: state.isActionLoading ? null : _submit,
                    //isLoading: state.isActionLoading,
                    label: isEditing ? "تحديث الحساب" : "إضافة الحساب",
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    final types = [
      PayoutAccountType.instaPay,
      PayoutAccountType.vodafoneCash,
      PayoutAccountType.bankAccount,
    ];

    return Row(
      children: types.map((type) {
        final isSelected = _selectedType == type;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() => _selectedType = type);
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.s12,
                    horizontal: AppSizes.s8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? type.color.withValues(alpha: 0.1)
                        : AppColors.backgroundMuted,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? type.color : AppColors.border,
                      width: isSelected ? 1.8 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSizes.s8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? type.color
                              : AppColors.borderStrong.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          type.icon,
                          size: 18,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSizes.s8),
                      Text(
                        type == PayoutAccountType.instaPay
                            ? "InstaPay"
                            : type == PayoutAccountType.vodafoneCash
                                ? "محفظة كاش"
                                : "حساب بنكي",
                        style: AppTextStyles.label.copyWith(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? type.color : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

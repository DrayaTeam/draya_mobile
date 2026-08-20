import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/core/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';

class TeacherTopUpCard extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final bool isLoading;
  final VoidCallback onTopUp;
  final ValueChanged<String>? onAmountChanged;

  const TeacherTopUpCard({
    super.key,
    required this.controller,
    required this.onTopUp,
    this.errorText,
    this.isLoading = false,
    this.onAmountChanged,
  });

  @override
  State<TeacherTopUpCard> createState() => _TeacherTopUpCardState();
}

class _TeacherTopUpCardState extends State<TeacherTopUpCard> {
  final List<double> _presetAmounts = const [50, 100, 200, 500];
  double? _selectedPreset;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_syncPresetSelection);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncPresetSelection);
    super.dispose();
  }

  void _syncPresetSelection() {
    final text = widget.controller.text.trim();
    final parsed = double.tryParse(text);
    if (parsed != null && _presetAmounts.contains(parsed)) {
      if (_selectedPreset != parsed) {
        setState(() => _selectedPreset = parsed);
      }
    } else {
      if (_selectedPreset != null) {
        setState(() => _selectedPreset = null);
      }
    }
  }

  void _selectPreset(double amount) {
    widget.controller.text = amount.toStringAsFixed(0);
    setState(() => _selectedPreset = amount);
    if (widget.onAmountChanged != null) {
      widget.onAmountChanged!(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.s8),
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add_card_rounded,
                  color: AppColors.primary700,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "شحن رصيد المحفظة",
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      "اختر قيمة الشحن السريع أو أدخل مبلغاً مخصصاً",
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

          // Preset Amount Chips
          Text(
            "مبالغ سريعة",
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _presetAmounts.map((amount) {
                final isSelected = _selectedPreset == amount;
                return Padding(
                  padding: const EdgeInsets.only(left: AppSizes.s8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _selectPreset(amount),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.s16,
                          vertical: AppSizes.s8 + 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary700
                              : AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary700
                                : AppColors.borderStrong,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) ...[
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              "${amount.toStringAsFixed(0)} ج.م",
                              style: AppTextStyles.label.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSizes.s16),

          // Custom Amount Input
          Text(
            "المبلغ المراد شحنه",
            style: AppTextStyles.label.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
          AppTextFormField(
            controller: widget.controller,
            hintText: "أدخل المبلغ (مثال: 150)",
            prefixIcon: Icons.payments_outlined,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            errorText: widget.errorText,
            suffixIcon: Icons.attach_money_rounded,
          ),

          const SizedBox(height: AppSizes.s16),

          // Action Button
          ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onTopUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary700,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 18,
                      ),
                      const SizedBox(width: AppSizes.s8),
                      Text(
                        "متابعة الدفع والشحن",
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: AppSizes.s12),

          // Security notice
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                "عملية دفع مشفرة وآمنة 100% عبر بوابات معتمدة",
                style: AppTextStyles.body.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

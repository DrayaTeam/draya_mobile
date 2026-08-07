import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'fade_in_up_animation.dart';

class AppDropDownFormField extends StatelessWidget {
  final String? hint;
  final String? value;
  final List<String>? items;
  final List<DropdownMenuItem<String>>? dropDownItems;
  final ValueChanged<String?> onChanged;
  final bool? isRequired;
  final TextStyle? textStyle;
  final double? verticalPadding;

  const AppDropDownFormField({
    super.key,
    this.hint,
    this.value,
    this.items,
    required this.onChanged,
    this.isRequired = true,
    this.dropDownItems,
    this.textStyle,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: value,
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.textSecondary,
          size: AppSizes.s24,
        ),
      ),
      isExpanded: true,
      style: textStyle ?? AppTextStyles.body,
      dropdownStyleData: DropdownStyleData(
        elevation: 4,
        maxHeight: AppSizes.s200,
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.zero,
      ),
      hint: hint == null
          ? null
          : Text(
              hint!,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
      validator: isRequired == true
          ? (value) => value == null ? "يرجى اختيار قيمة" : null
          : null,
      decoration: InputDecoration(
        fillColor: AppColors.primary50,
        contentPadding: EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: verticalPadding ?? 14,
        ),
      ),
      items:
          dropDownItems ??
          items
              ?.map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: FadeInUp(delay: 200, child: Text(item)),
                ),
              )
              .toList(),
      onChanged: onChanged,
    );
  }
}

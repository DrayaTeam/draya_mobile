import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final String hintText;
  final bool isObscure;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool isReadOnly;
  final bool? isEnabled;
  final int? maxLine;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final Function(String)? onChanged;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscure = false,
    this.keyboardType,
    this.suffixIcon,
    this.isReadOnly = false,
    this.onTap,
    this.validator,
    this.maxLine,
    this.onChanged,
    this.isEnabled,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.prefixIcon,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = !widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isObscure ? !_isPasswordVisible : false,
      enabled: widget.isEnabled ?? true,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      validator: widget.validator,
      onTap: widget.onTap,
      maxLines: widget.maxLine ?? 1,
      readOnly: widget.isReadOnly,
      style: AppTextStyles.body,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        if (widget.nextFocusNode != null) widget.nextFocusNode?.requestFocus();
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: AppColors.textSecondary,
                size: 24,
              )
            : null,
        suffixIcon: widget.isObscure
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                child: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              )
            : (widget.suffixIcon != null
                  ? Icon(
                      widget.suffixIcon,
                      color: AppColors.textSecondary,
                      size: 24,
                    )
                  : null),
        fillColor: widget.isEnabled == false
            ? AppColors.backgroundMuted
            : AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

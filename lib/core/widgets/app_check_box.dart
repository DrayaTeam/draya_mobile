import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppCheckBox extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;
  const AppCheckBox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (val) {
            onChanged(val!);
          },
          activeColor: AppColors.primary,
          checkColor: AppColors.surface,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ), 
          side: const BorderSide(color: AppColors.borderStrong),
        ),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

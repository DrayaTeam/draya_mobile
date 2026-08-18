import 'package:draya_mobile/core/helpers/app_extensions.dart';
import 'package:draya_mobile/core/networking/api_error_model.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

class AppErrorDialog extends StatelessWidget {
  final ApiErrorModel apiErrorModel;
  final VoidCallback? onRetry;

  const AppErrorDialog({
    super.key,
    required this.apiErrorModel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final errorMessage = _getErrorMessage();

    final canRetry = apiErrorModel.retry && onRetry != null;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      icon: const Icon(
        Icons.error_outline,
        color: AppColors.error,
        size: AppSizes.s48,
        semanticLabel: "خطأ",
      ),
      title: Text(
        errorMessage,
        textAlign: TextAlign.center,
        style: context.textTheme.titleMedium?.copyWith(
          color: AppColors.primary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);

            if (canRetry) {
              onRetry!();
            }
          },
          child: Text(
            canRetry
                ? "حاول مرة أخرى"
                : apiErrorModel.retry
                ? "حاول لاحقًا"
                : "حسنًا",
            style: context.textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  String _getErrorMessage() {
    final message = apiErrorModel.error?.message;

    if (message != null && message.trim().isNotEmpty) {
      return message.trim();
    }

    return 'حصل خطأ ما، يرجى المحاولة لاحقًا';
  }
}

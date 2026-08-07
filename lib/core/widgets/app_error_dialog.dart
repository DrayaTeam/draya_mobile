import 'package:draya_mobile/core/networking/api_error_model.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppErrorDialog extends StatelessWidget {
  final ApiErrorModel apiErrorModel;
  final Function()? onRetry;

  const AppErrorDialog({
    super.key,
    required this.apiErrorModel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final String errorMessage =
        apiErrorModel.error?.message != null &&
            apiErrorModel.error!.message!.isNotEmpty
        ? apiErrorModel.error!.message!
        : "حصل خطأ ما، يرجى المحاولة لاحقًا";
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: _errorIcon(),
      title: _errorMessageText(context, errorMessage),
      actions: [
        // apiErrorModel.error?.code == "401"
        //     ? _logoutTextButton(context)
        //     :
        apiErrorModel.retry
            ? onRetry == null
                  ? _errorTextButton(
                      context,
                      "حاول لاحقًا",
                    )
                  : _onRetryTextButton(context)
            : _errorTextButton(context, "حسنًا"),
      ],
    );
  }

  Widget _errorIcon() {
    return const Icon(
      Icons.error_outline,
      color: Colors.red,
      size: 48,
    );
  }

  Widget _errorMessageText(BuildContext context, String errorMessage) {
    return Text(
      errorMessage,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: AppColors.primary,
      ),
    );
  }

  // Widget _logoutTextButton(BuildContext context) {
  //   return TextButton(
  //     onPressed: () async {
  //       Navigator.of(context).pop();
  //       await AppSharedPrefHelper.clearAllSecuredData();
  //       if (context.mounted) {
  //         AppNavigator.goAndRemove(
  //           context: context,
  //           path: AppRoutes.signinPage,
  //         );
  //       }
  //     },
  //     child: Text(
  //       "تسجيل الخروج",
  //       style: Theme.of(context).textTheme.titleMedium!.copyWith(
  //         color: AppColors.error,
  //       ),
  //     ),
  //   );
  // }

  Widget _onRetryTextButton(BuildContext context) {
    {
      return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onRetry!();
        },
        child: Text(
          "حاول مرة أخرى",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: AppColors.primary,
          ),
        ),
      );
    }
  }

  Widget _errorTextButton(BuildContext context, String text) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}

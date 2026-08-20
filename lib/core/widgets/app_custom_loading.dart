import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/widgets/animated_fading_wrapper.dart";
import "package:flutter/material.dart";

class AppCustomLoading extends StatelessWidget {
  final String? text;
  const AppCustomLoading({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedFadingWrapper(
      child: Dialog(
        elevation: 0,
        backgroundColor: AppColors.surface,
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 50,
            vertical: 32,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppColors.primary,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                text ?? "تحميل ...",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

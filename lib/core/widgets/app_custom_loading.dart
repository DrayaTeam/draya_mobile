import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/widgets/animated_fading_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCustomLoading extends StatelessWidget {
  final String? text;
  const AppCustomLoading({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedFadingWrapper(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.white,
        constraints: BoxConstraints(maxHeight: 500.h, maxWidth: 500.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 50.w,
            vertical: 32.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppColors.primary,
              ),
              SizedBox(
                height: 12.h,
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

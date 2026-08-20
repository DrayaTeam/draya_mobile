import "package:draya_mobile/core/helpers/assets_helper.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";

class StudentHomeWelcomeCard extends StatelessWidget {
  const StudentHomeWelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 326,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppImages.studentDashboardImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 326,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(15, 79, 73, 0.8),
                    Color.fromRGBO(20, 95, 88, 0.75),
                    Color.fromRGBO(30, 120, 110, 0.7),
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: const Offset(0, 25),
                    blurRadius: 50,
                    spreadRadius: -12,
                  ),
                ],
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            Positioned(
              top: 24,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "الأحد، 20 يوليو 2026",
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60,
              right: 26,
              left: 94,
              child: Text(
                "أهلاً بعودتك، أحمد! 👋",
                textAlign: TextAlign.right,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.surface,
                  letterSpacing: -0.6,
                ),
              ),
            ),
            Positioned(
              top: 100,
              right: 40,
              left: 32,
              child: Text(
                "لديك اختبـاران مجدولان قريباً هذا الأسبوع. واصل الدراسة يومياً وحافظ على لهيب حماسك!",
                textAlign: TextAlign.right,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.surface.withValues(alpha: 0.85),
                  height: 1.64,
                ),
              ),
            ),
            Positioned(
              top: 186,
              left: 33,
              right: 33,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 20),
                      blurRadius: 25,
                      spreadRadius: -5,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 8),
                      blurRadius: 10,
                      spreadRadius: -6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "تابع من حيث توقفت",
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.primary900,
                        fontSize: 14,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Color(0xFF0F4F49),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 248,
              left: 33,
              right: 33,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "تصفح المواد الجديدة",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: AppSizes.s12),
                    Icon(
                      Icons.arrow_outward_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class StudentHomeFocusSection extends StatelessWidget {
  const StudentHomeFocusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'متابعة دروسك اليومية',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'عرض كل المواد',
            style: AppTextStyles.label.copyWith(
              color: AppColors.primary600,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          const _FocusCard(
            title: 'الجبر وحساب المثلثات',
            progressLabel: '68%',
            progressText: 'إنجاز الكورس',
            actionLabel: 'استئناف المشاهدة',
            progressColor: Color(0xFF00A6F4),
            tagLabel: 'الرياضيات',
            tagBackground: Color.fromRGBO(0, 0, 0, 0.4),
          ),
          const SizedBox(height: 16),
          const _FocusCard(
            title: 'الفيزياء الكهربية والحديثة',
            progressLabel: '40%',
            progressText: 'إنجاز الكورس',
            actionLabel: 'استئناف المشاهدة',
            progressColor: Color(0xFFAD46FF),
            tagLabel: 'الفيزياء',
            tagBackground: Color.fromRGBO(0, 0, 0, 0.4),
          ),
          const SizedBox(height: 16),
          const _FocusCard(
            title: 'الكيمياء العضوية المتقدمة',
            progressLabel: '85%',
            progressText: 'إنجاز الكورس',
            actionLabel: 'استئناف المشاهدة',
            progressColor: Color(0xFF00BC7D),
            tagLabel: 'الكيمياء',
            tagBackground: Color.fromRGBO(0, 0, 0, 0.4),
          ),
        ],
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  final String title;
  final String progressLabel;
  final String progressText;
  final String actionLabel;
  final Color progressColor;
  final String tagLabel;
  final Color tagBackground;

  const _FocusCard({
    required this.title,
    required this.progressLabel,
    required this.progressText,
    required this.actionLabel,
    required this.progressColor,
    required this.tagLabel,
    required this.tagBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: const AssetImage('assets/images/course_card_bg.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.08),
                    BlendMode.dstATop,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 21,
            right: 21,
            top: 21,
            child: Container(
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.6),
                            Colors.black.withValues(alpha: 0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tagBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        tagLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    left: 8,
                    top: 20,
                    child: Text(
                      title,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 21,
            right: 21,
            top: 169,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  progressLabel,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  progressText,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primary900,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 10,
                    color: const Color(0xFFF1F5F9),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.68,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              progressColor,
                              progressColor.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    actionLabel,
                    style: const TextStyle(
                      color: Color(0xFF0F4F49),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

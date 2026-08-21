import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class TeacherDashboardQuickActions extends StatelessWidget {
  const TeacherDashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.primary700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "الوصول السريع",
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                offset: const Offset(0, 8),
                blurRadius: 20,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ActionTile(
                title: "إنشاء اختبار",
                icon: Icons.auto_awesome_rounded,
                iconColor: const Color(0xFF0F766E),
                backgroundColor: const Color(0xFFF0FDFA),
                onTap: () => context.push(AppRoutes.examGenerationPage1),
              ),
              _ActionTile(
                title: "الفصول",
                icon: Icons.school_outlined,
                iconColor: const Color(0xFF2563EB),
                backgroundColor: const Color(0xFFEFF6FF),
                onTap: () => context.push(AppRoutes.classroomsPage),
              ),
              _ActionTile(
                title: "الطلبة",
                icon: Icons.group_outlined,
                iconColor: const Color(0xFF7C3AED),
                backgroundColor: const Color(0xFFF5F3FF),
                onTap: () => context.push(AppRoutes.studentsListPage),
              ),
              _ActionTile(
                title: "حسابي",
                icon: Icons.person_outline_rounded,
                iconColor: const Color(0xFFD97706),
                backgroundColor: const Color(0xFFFFFBEB),
                onTap: () => context.push(AppRoutes.teacherProfilePage),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

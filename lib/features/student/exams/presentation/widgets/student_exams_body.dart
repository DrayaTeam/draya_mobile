import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/exam_item.dart';
import 'exam_card_item.dart';

class StudentExamsBody extends StatelessWidget {
  const StudentExamsBody({super.key});

  static final List<ExamItem> _mockExams = [
    const ExamItem(
      subject: 'الرياضيات',
      title: 'امتحان الجبر والتباديل والتوافيق',
      teacher: 'أ. أحمد السيد',
      statusLabel: 'متاح للحل الآن 🔥',
      statusColor: AppColors.amber,
      duration: '45 دقيقة',
      extraLabel: 'جاهز للبدء',
      extraColor: AppColors.amber,
      actionLabel: 'بدء الامتحان الآن',
      actionEnabled: true,
      actionColor: AppColors.primary700,
      subjectAccentColor: AppColors.primary100,
      subjectTextColor: AppColors.primary800,
    ),
    const ExamItem(
      subject: 'الفيزياء',
      title: 'مراجعة قوانين نيوتن والكهربية',
      teacher: 'أ. سارة حسن',
      statusLabel: 'مجدول لاحقاً',
      statusColor: AppColors.mathPhysics,
      duration: '60 دقيقة',
      extraLabel: 'الخميس القادم 11:00 ص',
      extraColor: AppColors.mathPhysics,
      actionLabel: 'غير متاح بعد',
      actionEnabled: false,
      actionColor: AppColors.textSecondary,
      subjectAccentColor: AppColors.backgroundMuted,
      subjectTextColor: AppColors.textPrimary,
    ),
    const ExamItem(
      subject: 'الرياضيات',
      title: 'امتحان الفصل الدراسي الأول التراكمي',
      teacher: 'أ. أحمد السيد',
      statusLabel: 'مكتمل وحاصل على درجة',
      statusColor: AppColors.success,
      duration: '90 دقيقة',
      extraLabel: 'الدرجة: 85%',
      extraColor: AppColors.success,
      actionLabel: 'عرض تحليل النتيجة والتصحيح',
      actionEnabled: true,
      actionColor: AppColors.primary700,
      subjectAccentColor: AppColors.primary100,
      subjectTextColor: AppColors.primary800,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s20,
          vertical: AppSizes.s16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s16,
                vertical: AppSizes.s4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.solidStar,
                    color: AppColors.amber,
                    size: 12,
                  ),
                  const SizedBox(width: AppSizes.s4),
                  Text(
                    'مركز التقويم والاختبارات التفاعلية',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary700,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.s12),
            Text(
              'الامتحانات والواجبات المجدولة',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSizes.s8),
            Text(
              'استعرض الامتحانات والواجبات المحددة لك من قبل معلميك مع متابعة درجات التصحيح الفوري.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.s24),
            Expanded(
              child: ListView.builder(
                itemCount: _mockExams.length,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final exam = _mockExams[index];
                  return ExamCardItem(
                    exam: exam,
                    onActionTap: exam.actionEnabled
                        ? () => AppNavigator.push(
                              context: context,
                              path: AppRoutes.studentExamDetailsPage,
                              extra: exam,
                            )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

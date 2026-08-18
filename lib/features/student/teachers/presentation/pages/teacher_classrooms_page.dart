import 'dart:async';

import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/core/widgets/fade_in_up_animation.dart';
import 'package:draya_mobile/features/student/teachers/data/models/teacher_classroom_model.dart';
import 'package:draya_mobile/features/student/teachers/data/models/teacher_model.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/student_checkout_cubit.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/student_checkout_state.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/teacher_classrooms_cubit.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/teacher_classrooms_state.dart';
import 'package:draya_mobile/features/teacher/payments/data/models/payment_webview_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TeacherClassroomsPage extends StatefulWidget {
  final String teacherId;
  final TeacherModel? teacher;

  const TeacherClassroomsPage({
    super.key,
    required this.teacherId,
    this.teacher,
  });

  @override
  State<TeacherClassroomsPage> createState() => _TeacherClassroomsPageState();
}

class _TeacherClassroomsPageState extends State<TeacherClassroomsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TeacherClassroomsCubit>().getTeacherClassrooms(
      widget.teacherId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TeacherClassroomsCubit, TeacherClassroomsState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == CubitStatus.error,
          listener: (context, state) {
            if (state.apiErrorModel != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.apiErrorModel?.error?.message ??
                        'تعذر تحميل الفصول الدراسية',
                    style: AppTextStyles.body.copyWith(color: Colors.white),
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        ),
        BlocListener<StudentCheckoutCubit, StudentCheckoutState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) async {
            switch (state.status) {
              case CubitStatus.loading:
                unawaited(
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                );
                break;
              case CubitStatus.success:
                if (Navigator.of(context, rootNavigator: true).canPop()) {
                  Navigator.of(context, rootNavigator: true).pop();
                }

                final checkoutUrl = state.checkoutResponse?.checkoutUrl;
                if (checkoutUrl == null || checkoutUrl.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تعذر إنشاء رابط الدفع.',
                        style: AppTextStyles.body.copyWith(color: Colors.white),
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  break;
                }

                await AppNavigator.push(
                  context: context,
                  path: AppRoutes.paymentWebViewPage,
                  extra: PaymentWebviewModel(
                    appBarTitle: 'الدفع الإلكتروني',
                    url: checkoutUrl,
                  ),
                );
                break;
              case CubitStatus.error:
                if (Navigator.of(context, rootNavigator: true).canPop()) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.apiErrorModel?.error?.message ??
                          'تعذر إتمام تسجيل الفصل',
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
                break;
              case CubitStatus.initial:
                break;
            }
          },
        ),
      ],
      child: BlocBuilder<TeacherClassroomsCubit, TeacherClassroomsState>(
        builder: (context, state) {
          final classrooms = state.classrooms;
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: CustomAppBar(
              title: widget.teacher?.fullName ?? 'الفصول الدراسية',
            ),
            body: SafeArea(
              child: state.status == CubitStatus.loading && classrooms.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => context
                          .read<TeacherClassroomsCubit>()
                          .getTeacherClassrooms(widget.teacherId),
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSizes.s16,
                          AppSizes.s16,
                          AppSizes.s16,
                          AppSizes.s32,
                        ),
                        children: [
                          _HeaderCard(
                            teacherName: widget.teacher?.fullName ?? 'المعلم',
                            specialization:
                                widget.teacher?.specialization ?? 'عام',
                            classroomCount: classrooms.length,
                          ),
                          const SizedBox(height: 18),
                          if (classrooms.isEmpty)
                            _EmptyClassroomsState(
                              teacherName: widget.teacher?.fullName ?? 'المعلم',
                            )
                          else
                            ...classrooms.asMap().entries.map(
                              (entry) {
                                final index = entry.key;
                                final classroom = entry.value;
                                final card = _ClassroomCard(
                                  classroom: classroom,
                                  onEnroll: () =>
                                      _handleEnroll(context, classroom),
                                );
                                if (index < 5) {
                                  return FadeInUp(
                                    delay: index * 50,
                                    child: card,
                                  );
                                }
                                return card;
                              },
                            ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleEnroll(
    BuildContext context,
    TeacherClassroomModel classroom,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.payment_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'تسجيل في الفصل',
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'هل تريد التسجيل في الفصل "${classroom.name}" مقابل ${classroom.price.toStringAsFixed(0)} جنيه عبر بوابة Paymob؟',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.foregroundMuted,
                        side: const BorderSide(color: AppColors.borderStrong),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'إلغاء',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.foregroundMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'متابعة الدفع',
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      unawaited(
        context.read<StudentCheckoutCubit>().checkoutClassroom(
          classroom.classroomId,
        ),
      );
    }
  }
}

class _HeaderCard extends StatelessWidget {
  final String teacherName;
  final String specialization;
  final int classroomCount;

  const _HeaderCard({
    required this.teacherName,
    required this.specialization,
    required this.classroomCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary800, AppColors.primary600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary700.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacherName,
                      style: AppTextStyles.h4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'المعلم المشرف',
                      style: AppTextStyles.label.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  specialization,
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  '$classroomCount فصل متاح',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClassroomCard extends StatelessWidget {
  final TeacherClassroomModel classroom;
  final VoidCallback onEnroll;

  const _ClassroomCard({
    required this.classroom,
    required this.onEnroll,
  });

  @override
  Widget build(BuildContext context) {
    final startText = classroom.startDate != null
        ? DateFormat('dd/MM/yyyy', 'ar').format(classroom.startDate!)
        : 'بدء غير محدد';
    final endText = classroom.endDate != null
        ? DateFormat('dd/MM/yyyy', 'ar').format(classroom.endDate!)
        : 'انتهاء غير محدد';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        classroom.name,
                        style: AppTextStyles.h5.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        classroom.subjectName,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: classroom.isActive
                        ? AppColors.success.withValues(alpha: 0.12)
                        : AppColors.amber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: classroom.isActive
                          ? AppColors.success.withValues(alpha: 0.3)
                          : AppColors.amber.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    classroom.isActive ? 'مفتوح للتسجيل' : 'غير نشط',
                    style: AppTextStyles.label.copyWith(
                      color: classroom.isActive
                          ? AppColors.success
                          : AppColors.amber,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.category_outlined,
                    label: 'نوع الفصل',
                    value: classroom.classroomTypeName,
                  ),
                  const Divider(color: AppColors.border, height: 12),
                  _InfoRow(
                    icon: Icons.grade_outlined,
                    label: 'المرحلة',
                    value: classroom.gradeLevelName,
                  ),
                  const Divider(color: AppColors.border, height: 12),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'المدة',
                    value: '$startText - $endText',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سعر الاشتراك',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${classroom.price.toStringAsFixed(0)} جنيه',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: classroom.isActive ? onEnroll : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.borderStrong,
                    disabledForegroundColor: AppColors.textDisabled,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.credit_card_rounded, size: 18),
                  label: Text(
                    'تسجيل الآن',
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.foregroundMuted),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyles.label.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyClassroomsState extends StatelessWidget {
  final String teacherName;

  const _EmptyClassroomsState({required this.teacherName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary200),
            ),
            child: const Icon(
              Icons.school_outlined,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد فصول متاحة حالياً',
            style: AppTextStyles.h5.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'لم يقم $teacherName بإنشاء أي فصول دراسية حتى الآن.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


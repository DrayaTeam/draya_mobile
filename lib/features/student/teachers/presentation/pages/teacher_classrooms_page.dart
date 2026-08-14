import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/core/widgets/app_custom_loading.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/student/teachers/data/models/teacher_classroom_model.dart';
import 'package:draya_mobile/features/student/teachers/data/models/teacher_model.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/teacher_classrooms_cubit.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/teacher_classrooms_state.dart';
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
    return BlocConsumer<TeacherClassroomsCubit, TeacherClassroomsState>(
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
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
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
                    child: AppCustomLoading(text: 'جاري تحميل الفصول...'),
                  )
                : RefreshIndicator(
                    onRefresh: () => context
                        .read<TeacherClassroomsCubit>()
                        .getTeacherClassrooms(widget.teacherId),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.s20,
                        AppSizes.s20,
                        AppSizes.s20,
                        AppSizes.s32,
                      ),
                      children: [
                        _HeaderCard(
                          teacherName: widget.teacher?.fullName ?? 'المعلم',
                          specialization:
                              widget.teacher?.specialization ?? 'الصفحة',
                        ),
                        const SizedBox(height: AppSizes.s20),
                        if (classrooms.isEmpty)
                          _EmptyClassroomsState(
                            teacherName: widget.teacher?.fullName ?? 'المعلم',
                          )
                        else
                          ...classrooms.map(
                            (classroom) => _ClassroomCard(
                              classroom: classroom,
                              onEnroll: () => _handleEnroll(context, classroom),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Future<void> _handleEnroll(
    BuildContext context,
    TeacherClassroomModel classroom,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل في الفصل'),
        content: Text(
          'هل تريد التسجيل في الفصل "${classroom.name}" مقابل ${classroom.price.toStringAsFixed(0)} ر.س عبر Paymob؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('متابعة الدفع'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('سيتم ربط بوابة Paymob في هذه المرحلة.'),
          backgroundColor: AppColors.primary700,
        ),
      );
    }
  }
}

class _HeaderCard extends StatelessWidget {
  final String teacherName;
  final String specialization;

  const _HeaderCard({
    required this.teacherName,
    required this.specialization,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary700, AppColors.primary500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.s20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(27, 109, 99, 0.24),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: Text(
                  'الفصول المتاحة',
                  style: AppTextStyles.h4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s20),
          Text(
            teacherName,
            style: AppTextStyles.h5.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s12,
              vertical: AppSizes.s8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.24),
                width: 1,
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

    return Semantics(
      button: true,
      label: 'تسجيل في الفصل ${classroom.name}',
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.s16),
        padding: const EdgeInsets.all(AppSizes.s16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.s20),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(17, 24, 39, 0.04),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
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
                      const SizedBox(height: AppSizes.s8),
                      Text(
                        classroom.subjectName,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.s12,
                    vertical: AppSizes.s8,
                  ),
                  decoration: BoxDecoration(
                    color: classroom.isActive
                        ? AppColors.success.withValues(alpha: 0.12)
                        : AppColors.amber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    classroom.isActive ? 'نشط' : 'غير نشط',
                    style: AppTextStyles.label.copyWith(
                      color: classroom.isActive
                          ? AppColors.success
                          : AppColors.amber,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s16),
            Container(
              padding: const EdgeInsets.all(AppSizes.s12),
              decoration: BoxDecoration(
                color: AppColors.backgroundMuted,
                borderRadius: BorderRadius.circular(AppSizes.s16),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    label: 'نوع الفصل',
                    value: classroom.classroomTypeName,
                  ),
                  _InfoRow(label: 'المرحلة', value: classroom.gradeLevelName),
                  _InfoRow(
                    label: 'الطلبة',
                    value: '${classroom.studentCount} طالب',
                  ),
                  _InfoRow(label: 'التاريخ', value: '$startText - $endText'),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.s16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.s8),
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(AppSizes.s8),
                  ),
                  child: const Icon(
                    Icons.payments_outlined,
                    color: AppColors.primary700,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSizes.s8),
                Text(
                  '${classroom.price.toStringAsFixed(0)} جنيه',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.primary700,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: onEnroll,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s16,
                      vertical: AppSizes.s12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.s12),
                    ),
                  ),
                  icon: const Icon(Icons.credit_card_outlined, size: 18),
                  label: const Text('تسجيل الآن'),
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
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.s8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyClassroomsState extends StatelessWidget {
  final String teacherName;

  const _EmptyClassroomsState({required this.teacherName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.s16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.school_outlined,
            size: 42,
            color: AppColors.primary700,
          ),
          const SizedBox(height: AppSizes.s12),
          Text(
            'لا توجد فصول متاحة حاليًا لــ $teacherName',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

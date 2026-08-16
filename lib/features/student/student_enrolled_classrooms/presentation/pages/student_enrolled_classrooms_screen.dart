import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_custom_loading.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/domain/entity/student_enrolled_classroom.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/presentation/cubit/student_enrolled_classrooms_cubit.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/presentation/cubit/student_enrolled_classrooms_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class StudentEnrolledClassroomsScreen extends StatefulWidget {
  const StudentEnrolledClassroomsScreen({super.key});

  @override
  State<StudentEnrolledClassroomsScreen> createState() =>
      _StudentEnrolledClassroomsScreenState();
}

class _StudentEnrolledClassroomsScreenState
    extends State<StudentEnrolledClassroomsScreen> {
  final _enrollmentCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<StudentEnrolledClassroomsCubit>().getStudentEnrolledClassrooms();
  }

  @override
  void dispose() {
    _enrollmentCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'فصولي'),
      drawer: AppDrawer(drawerItemsList: getStudentDrawerItemsList()),
      backgroundColor: AppColors.background,
      body: BlocConsumer<StudentEnrolledClassroomsCubit,
          StudentEnrolledClassroomsState>(
        listener: (context, state) {
          if (state.status == CubitStatus.error &&
              state.apiErrorModel?.error?.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.apiErrorModel!.error!.message!),
                backgroundColor: AppColors.error,
              ),
            );
          }
          if (state.status == CubitStatus.success &&
              state.apiErrorModel == null) {
            _enrollmentCodeController.clear();
          }
        },
        builder: (context, state) {
          if (state.status == CubitStatus.loading && state.classrooms.isEmpty) {
            return const Center(
              child: AppCustomLoading(text: 'جاري تحميل الفصول...'),
            );
          }

          if (state.status == CubitStatus.error && state.classrooms.isEmpty) {
            return _ErrorState(
              message: state.apiErrorModel?.error?.message ??
                  'تعذر تحميل الفصول الدراسية.',
              onRetry: () => context
                  .read<StudentEnrolledClassroomsCubit>()
                  .getStudentEnrolledClassrooms(),
            );
          }

          final classrooms = state.classrooms;

          return RefreshIndicator(
            onRefresh: () => context
                .read<StudentEnrolledClassroomsCubit>()
                .getStudentEnrolledClassrooms(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.s16,
                AppSizes.s16,
                AppSizes.s16,
                AppSizes.s32,
              ),
              children: [
                _TopSummaryCard(
                  totalClassrooms: classrooms.length,
                  totalCount: state.totalCount,
                  enrollmentCodeController: _enrollmentCodeController,
                  onEnroll: () {
                    final code = _enrollmentCodeController.text;
                    if (code.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('يرجى إدخال رمز الفصل'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }

                    context
                        .read<StudentEnrolledClassroomsCubit>()
                        .enrollClassroom(code);
                  },
                  isLoading: state.status == CubitStatus.loading,
                ),
                const SizedBox(height: AppSizes.s20),
                if (classrooms.isEmpty)
                  _EmptyState(
                    onRefresh: () => context
                        .read<StudentEnrolledClassroomsCubit>()
                        .getStudentEnrolledClassrooms(),
                  )
                else
                  ...classrooms.asMap().entries.map((entry) {
                    final index = entry.key;
                    final classroom = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == classrooms.length - 1
                            ? AppSizes.s8
                            : AppSizes.s12,
                      ),
                      child: _ClassroomCard(classroom: classroom),
                    );
                  }),
                if (state.status == CubitStatus.loading && classrooms.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.s16),
                    child: Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  ),
                if (state.page < state.totalPages)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSizes.s16),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: state.status == CubitStatus.loading
                            ? null
                            : () => context
                                .read<StudentEnrolledClassroomsCubit>()
                                .getStudentEnrolledClassrooms(
                                  page: state.page + 1,
                                  pageSize: state.pageSize,
                                ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary700,
                          side: const BorderSide(color: AppColors.primary300),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.s12),
                          ),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        label: const Text('تحميل المزيد'),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TopSummaryCard extends StatelessWidget {
  final int totalClassrooms;
  final int totalCount;
  final TextEditingController enrollmentCodeController;
  final VoidCallback onEnroll;
  final bool isLoading;

  const _TopSummaryCard({
    required this.totalClassrooms,
    required this.totalCount,
    required this.enrollmentCodeController,
    required this.onEnroll,
    required this.isLoading,
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
            color: Color.fromRGBO(27, 109, 99, 0.18),
            blurRadius: 18,
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                ),
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: AppSizes.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الفصول المسجلة',
                      style: AppTextStyles.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      '$totalClassrooms من $totalCount فصلاً',
                      style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s16),
          Container(
            padding: const EdgeInsets.all(AppSizes.s12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSizes.s16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: enrollmentCodeController,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'أدخل رمز الفصل',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.s12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s12,
                        vertical: AppSizes.s8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.s8),
                FilledButton.icon(
                  onPressed: isLoading ? null : onEnroll,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s12,
                      vertical: AppSizes.s12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.s12),
                    ),
                  ),
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_rounded),
                  label: Text(isLoading ? 'جارِ...' : 'تسجيل'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassroomCard extends StatelessWidget {
  final StudentEnrolledClassroom classroom;

  const _ClassroomCard({required this.classroom});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy', 'ar');
    final startDate = classroom.startDate != null
        ? dateFormat.format(classroom.startDate!)
        : 'تاريخ غير محدد';
    final endDate = classroom.endDate != null
        ? dateFormat.format(classroom.endDate!)
        : 'حتى الآن';

    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.s16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.04),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.primary700,
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classroom.name,
                      style: AppTextStyles.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      'المادة: ${classroom.subjectName}',
                      style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s8,
                  vertical: AppSizes.s4,
                ),
                decoration: BoxDecoration(
                  color: classroom.isActive
                      ? AppColors.primary100
                      : AppColors.backgroundMuted,
                  borderRadius: BorderRadius.circular(AppSizes.s8),
                ),
                child: Text(
                  classroom.isActive ? 'نشط' : 'غير نشط',
                  style: AppTextStyles.textTheme.labelMedium?.copyWith(
                    color: classroom.isActive ? AppColors.primary700 : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s16),
          Wrap(
            spacing: AppSizes.s8,
            runSpacing: AppSizes.s8,
            children: [
              _InfoChip(label: 'المرحلة', value: classroom.gradeLevelName),
              _InfoChip(label: 'النوع', value: classroom.classroomTypeName),
            ],
          ),
          const SizedBox(height: AppSizes.s12),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary700),
              const SizedBox(width: AppSizes.s4),
              Expanded(
                child: Text(
                  '$startDate - $endDate',
                  style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s24),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.push(
                      AppRoutes.studentChannelPage(classroom.classroomId),
                    ),
                    icon: const Icon(Icons.forum_outlined),
                    label: const Text('قناة الأسئلة'),
                  ),
                ),
                const SizedBox(width: AppSizes.s8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.push(
                      AppRoutes.studentClassroomMaterialsPage(
                        classroom.classroomId,
                      ),
                      extra: classroom.name,
                    ),
                    icon: const Icon(Icons.folder_copy_outlined),
                    label: const Text('المواد'),
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

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s8, vertical: AppSizes.s4),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSizes.s8),
      ),
      child: Text(
        '$label: $value',
        style: AppTextStyles.textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 56, color: AppColors.error),
            const SizedBox(height: AppSizes.s16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.s16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(AppSizes.s20),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 42,
                color: AppColors.primary700,
              ),
            ),
            const SizedBox(height: AppSizes.s20),
            Text(
              'لا توجد فصول مسجلة بعد',
              style: AppTextStyles.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.s8),
            Text(
              'ستظهر الفصول التي تنضم إليها هنا.',
              textAlign: TextAlign.center,
              style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.s20),
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('تحديث'),
            ),
          ],
        ),
      ),
    );
  }
}

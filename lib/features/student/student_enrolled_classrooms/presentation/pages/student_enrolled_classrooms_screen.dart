import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/core/widgets/fade_in_up_animation.dart';
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
    context
        .read<StudentEnrolledClassroomsCubit>()
        .getStudentEnrolledClassrooms();
  }

  @override
  void dispose() {
    _enrollmentCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'فصولي المسجلة'),
      drawer: AppDrawer(drawerItemsList: getStudentDrawerItemsList()),
      backgroundColor: AppColors.background,
      body:
          BlocConsumer<
            StudentEnrolledClassroomsCubit,
            StudentEnrolledClassroomsState
          >(
            listener: (context, state) {
              if (state.status == CubitStatus.error &&
                  state.apiErrorModel?.error?.message != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.apiErrorModel!.error!.message!,
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
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
              if (state.status == CubitStatus.loading &&
                  state.classrooms.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state.status == CubitStatus.error &&
                  state.classrooms.isEmpty) {
                return _ErrorState(
                  message:
                      state.apiErrorModel?.error?.message ??
                      'تعذر تحميل الفصول الدراسية.',
                  onRetry: () => context
                      .read<StudentEnrolledClassroomsCubit>()
                      .getStudentEnrolledClassrooms(),
                );
              }

              final classrooms = state.classrooms;

              return RefreshIndicator(
                color: AppColors.primary,
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
                            SnackBar(
                              content: Text(
                                'يرجى إدخال رمز الفصل',
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.white,
                                ),
                              ),
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
                    const SizedBox(height: 18),
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
                        final card = Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _ClassroomCard(classroom: classroom),
                        );

                        if (index < 6) {
                          return FadeInUp(
                            delay: index * 50,
                            child: card,
                          );
                        }
                        return card;
                      }),
                    if (state.page < state.totalPages)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Center(
                          child: SizedBox(
                            width: 200,
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
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(
                                  color: AppColors.primary300,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(
                                Icons.expand_more_rounded,
                                size: 20,
                              ),
                              label: Text(
                                'تحميل المزيد',
                                style: AppTextStyles.label.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
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
                      'فصولي الدراسية',
                      style: AppTextStyles.h4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$totalClassrooms من إجمالي $totalCount فصلاً مسجلاً',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: enrollmentCodeController,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintText: 'أدخل رمز الانضمام للفصل...',
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      hintStyle: AppTextStyles.body.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.vpn_key_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: isLoading ? null : onEnroll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        )
                      : const Icon(Icons.add_rounded, size: 18),
                  label: Text(
                    isLoading ? 'جارِ...' : 'انضمام',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
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

class _ClassroomCard extends StatelessWidget {
  final StudentEnrolledClassroom classroom;

  const _ClassroomCard({required this.classroom});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy', 'ar');
    final startDate = classroom.startDate != null
        ? dateFormat.format(classroom.startDate!)
        : 'غير محدد';
    final endDate = classroom.endDate != null
        ? dateFormat.format(classroom.endDate!)
        : 'مستمر';

    return Container(
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
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary200),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
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
                        : AppColors.backgroundMuted,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: classroom.isActive
                          ? AppColors.success.withValues(alpha: 0.3)
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    classroom.isActive ? 'نشط' : 'مكتمل',
                    style: AppTextStyles.label.copyWith(
                      color: classroom.isActive
                          ? AppColors.success
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _InfoPill(
                  icon: Icons.grade_outlined,
                  text: classroom.gradeLevelName,
                ),
                const SizedBox(width: 8),
                _InfoPill(
                  icon: Icons.category_outlined,
                  text: classroom.classroomTypeName,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.foregroundMuted,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$startDate - $endDate',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.push(
                      AppRoutes.studentChannelPage(classroom.classroomId),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary300),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.forum_outlined, size: 18),
                    label: Text(
                      'قناة الأسئلة',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.push(
                      AppRoutes.studentClassroomMaterialsPage(
                        classroom.classroomId,
                      ),
                      extra: classroom.name,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.folder_copy_outlined, size: 18),
                    label: Text(
                      'المواد الدراسية',
                      style: AppTextStyles.button.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
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

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.foregroundMuted),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.label.copyWith(
              color: AppColors.foregroundMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ في تحميل الفصول',
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'إعادة المحاولة',
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary200, width: 1.5),
              ),
              child: const Icon(
                Icons.school_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'لا توجد فصول مسجلة بعد',
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ستظهر الفصول التي تنضم إليها برمز أو تشترك بها هنا.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRefresh,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'تحديث القائمة',
                style: AppTextStyles.label.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

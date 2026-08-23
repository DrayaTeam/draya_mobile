import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_state.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

enum _ClassroomFilter { all, active, inactive }

class ClassroomsPage extends StatefulWidget {
  const ClassroomsPage({super.key});

  @override
  State<ClassroomsPage> createState() => _ClassroomsPageState();
}

class _ClassroomsPageState extends State<ClassroomsPage> {
  late final TextEditingController _searchController;
  String _query = "";
  _ClassroomFilter _selectedFilter = _ClassroomFilter.all;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<ClassroomCubit>().getClassrooms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ClassroomModel> _filteredClassrooms(List<ClassroomModel> classrooms) {
    return classrooms.where((classroom) {
      // Status filter
      if (_selectedFilter == _ClassroomFilter.active && !classroom.isActive) {
        return false;
      }
      if (_selectedFilter == _ClassroomFilter.inactive && classroom.isActive) {
        return false;
      }

      // Search query
      if (_query.trim().isEmpty) return true;
      final searchable =
          "${classroom.name} ${classroom.subjectName} ${classroom.enrollmentCode}"
              .toLowerCase();
      return searchable.contains(_query.trim().toLowerCase());
    }).toList();
  }

  void _createClassroom() {
    AppNavigator.push(
      context: context,
      path: AppRoutes.createClassroomPage,
    );
  }

  void _previewAsStudent(ClassroomModel classroom) {
    AppNavigator.push(
      context: context,
      path: AppRoutes.studentClassroomMaterialsPage(classroom.classroomId),
      extra: classroom.name,
    );
  }

  Future<void> _deleteClassroom({required String classroomId}) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.error,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Text("حذف الفصل"),
            ],
          ),
          content: Text(
            "هل أنت متأكد من حذف الفصل؟",
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("إلغاء"),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text("حذف نهائي"),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    await context.read<ClassroomCubit>().deleteClassroom(
      classroomId: classroomId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassroomCubit, ClassroomState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == CubitStatus.error,
      listener: (context, state) {
        if (state.apiErrorModel != null) {
          showDialog<void>(
            context: context,
            builder: (_) => AppErrorDialog(
              apiErrorModel: state.apiErrorModel!,
              onRetry: context.read<ClassroomCubit>().getClassrooms,
            ),
          );
        }
      },
      builder: (context, state) {
        final allClassrooms = state.classrooms;
        final filteredClassrooms = _filteredClassrooms(allClassrooms);
        final activeCount = allClassrooms.where((c) => c.isActive).length;
        final totalStudents = allClassrooms.fold<int>(
          0,
          (sum, c) => sum + c.studentCount,
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(title: "الفصول الدراسية"),
          drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
          body: SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: context.read<ClassroomCubit>().getClassrooms,
              child:
                  state.status == CubitStatus.loading && allClassrooms.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.s16,
                        AppSizes.s16,
                        AppSizes.s16,
                        AppSizes.s36,
                      ),
                      children: [
                        // Hero Header
                        _TeacherClassroomsHeroHeader(
                          totalClassrooms: allClassrooms.length,
                          activeClassrooms: activeCount,
                          totalStudents: totalStudents,
                          onCreateClassroom: _createClassroom,
                        ),
                        const SizedBox(height: AppSizes.s16),

                        // Search & Filter Section
                        _SearchBarWithFilters(
                          controller: _searchController,
                          query: _query,
                          selectedFilter: _selectedFilter,
                          totalCount: allClassrooms.length,
                          activeCount: activeCount,
                          inactiveCount: allClassrooms.length - activeCount,
                          onSearchChanged: (val) =>
                              setState(() => _query = val),
                          onClearSearch: () {
                            _searchController.clear();
                            setState(() => _query = "");
                          },
                          onFilterChanged: (filter) =>
                              setState(() => _selectedFilter = filter),
                        ),
                        const SizedBox(height: AppSizes.s16),

                        // Classrooms List / Empty State
                        if (allClassrooms.isEmpty)
                          _EmptyClassroomsState(
                            hasFilter: false,
                            onCreate: _createClassroom,
                          )
                        else if (filteredClassrooms.isEmpty)
                          _EmptyClassroomsState(
                            hasFilter: true,
                            onClearFilter: () {
                              _searchController.clear();
                              setState(() {
                                _query = "";
                                _selectedFilter = _ClassroomFilter.all;
                              });
                            },
                          )
                        else
                          ...filteredClassrooms.asMap().entries.map((entry) {
                            final index = entry.key;
                            final classroom = entry.value;
                            final card = _ModernClassroomCard(
                              classroom: classroom,
                              onViewStudents: () => context.push(
                                AppRoutes.classroomStudentsPage(
                                  classroom.classroomId,
                                ),
                                extra: classroom,
                              ),
                              onManageSections: () => AppNavigator.push(
                                context: context,
                                path: AppRoutes.sectionsPage,
                                extra: classroom,
                              ),
                              onOpenChannel: () => context.push(
                                AppRoutes.teacherChannelPage(
                                  classroom.classroomId,
                                ),
                              ),
                              onPreviewAsStudent: () =>
                                  _previewAsStudent(classroom),
                              onDeleteClassroom: () {
                                _deleteClassroom(
                                  classroomId: classroom.classroomId,
                                );
                              },
                            );

                            if (index < 6) {
                              return FadeInUp(
                                delay: index * 60,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSizes.s12,
                                  ),
                                  child: card,
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSizes.s12,
                              ),
                              child: card,
                            );
                          }),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Header Hero Card
// ---------------------------------------------------------------------------
class _TeacherClassroomsHeroHeader extends StatelessWidget {
  final int totalClassrooms;
  final int activeClassrooms;
  final int totalStudents;
  final VoidCallback onCreateClassroom;

  const _TeacherClassroomsHeroHeader({
    required this.totalClassrooms,
    required this.activeClassrooms,
    required this.totalStudents,
    required this.onCreateClassroom,
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
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "الفصول الدراسية",
                      style: AppTextStyles.h4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "إدارة الفصول والمحتوى والطلاب ومتابعة نشاطهم",
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stats Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _HeaderStatItem(
                  label: "إجمالي الفصول",
                  value: "$totalClassrooms",
                  icon: Icons.class_outlined,
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                _HeaderStatItem(
                  label: "فصول نشطة",
                  value: "$activeClassrooms",
                  icon: Icons.check_circle_outline,
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                _HeaderStatItem(
                  label: "إجمالي الطلبة",
                  value: "$totalStudents",
                  icon: Icons.groups_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Create Button CTA
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onCreateClassroom,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary800,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_circle_rounded, size: 20),
              label: Text(
                "إنشاء فصل دراسي جديد",
                style: AppTextStyles.label.copyWith(
                  color: AppColors.primary800,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _HeaderStatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.9)),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTextStyles.h5.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Search & Filter Component
// ---------------------------------------------------------------------------
class _SearchBarWithFilters extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final _ClassroomFilter selectedFilter;
  final int totalCount;
  final int activeCount;
  final int inactiveCount;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<_ClassroomFilter> onFilterChanged;

  const _SearchBarWithFilters({
    required this.controller,
    required this.query,
    required this.selectedFilter,
    required this.totalCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Field
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: controller,
              onChanged: onSearchChanged,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: "بحث باسم الفصل، المادة، أو كود الاشتراك...",
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textDisabled,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: AppColors.foregroundMuted,
                        ),
                        onPressed: onClearSearch,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: "الكل",
                  count: totalCount,
                  isSelected: selectedFilter == _ClassroomFilter.all,
                  onTap: () => onFilterChanged(_ClassroomFilter.all),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: "النشطة",
                  count: activeCount,
                  isSelected: selectedFilter == _ClassroomFilter.active,
                  activeColor: AppColors.chemistryBiology,
                  onTap: () => onFilterChanged(_ClassroomFilter.active),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: "غير النشطة",
                  count: inactiveCount,
                  isSelected: selectedFilter == _ClassroomFilter.inactive,
                  activeColor: AppColors.textSecondary,
                  onTap: () => onFilterChanged(_ClassroomFilter.inactive),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    this.activeColor = AppColors.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.border,
            width: isSelected ? 1.4 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: isSelected ? activeColor : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor
                    : AppColors.foregroundMuted.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                "$count",
                style: AppTextStyles.label.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Modern Classroom Card
// ---------------------------------------------------------------------------
class _ModernClassroomCard extends StatelessWidget {
  final ClassroomModel classroom;
  final VoidCallback onViewStudents;
  final VoidCallback onManageSections;
  final VoidCallback onOpenChannel;
  final VoidCallback onPreviewAsStudent;
  final VoidCallback onDeleteClassroom;

  const _ModernClassroomCard({
    required this.classroom,
    required this.onViewStudents,
    required this.onManageSections,
    required this.onOpenChannel,
    required this.onPreviewAsStudent,
    required this.onDeleteClassroom,
  });

  void _copyEnrollmentCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: classroom.enrollmentCode));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              "تم نسخ كود الانضمام: ${classroom.enrollmentCode}",
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Section: Subject & Status
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Subject Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_stories_rounded,
                              size: 13,
                              color: AppColors.primary700,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              classroom.subjectName,
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.primary700,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Active Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (classroom.isActive
                                      ? AppColors.chemistryBiology
                                      : AppColors.foregroundMuted)
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: classroom.isActive
                                    ? AppColors.chemistryBiology
                                    : AppColors.foregroundMuted,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              classroom.isActive ? "نشط" : "غير نشط",
                              style: AppTextStyles.label.copyWith(
                                color: classroom.isActive
                                    ? AppColors.chemistryBiology
                                    : AppColors.foregroundMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Classroom Name
                  Text(
                    classroom.name,
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Middle Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    // Students Count
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AppColors.primary50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.groups_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "الطلاب",
                                style: AppTextStyles.label.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10.5,
                                ),
                              ),
                              Text(
                                "${classroom.studentCount} طالب",
                                style: AppTextStyles.label.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: AppColors.border,
                    ),
                    const SizedBox(width: 10),
                    // Enrollment Code with Copy
                    Expanded(
                      child: InkWell(
                        onTap: () => _copyEnrollmentCode(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: AppColors.amber.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.key_rounded,
                                color: AppColors.amber,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "كود الانضمام",
                                    style: AppTextStyles.label.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                  Text(
                                    classroom.enrollmentCode,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.label.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.copy_rounded,
                              size: 14,
                              color: AppColors.foregroundMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            const Divider(color: AppColors.border, height: 1),

            // Actions Row
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                spacing: AppSizes.s8,
                children: [
                  Row(
                    spacing: AppSizes.s8,
                    children: [
                      // View Students Action
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton.icon(
                            onPressed: onViewStudents,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(
                              Icons.people_outline_rounded,
                              size: 16,
                            ),
                            label: Text(
                              "الطلاب",
                              style: AppTextStyles.label.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Manage Sections Action
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: OutlinedButton.icon(
                            onPressed: onManageSections,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(
                                color: AppColors.primary300,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(
                              Icons.folder_open_rounded,
                              size: 16,
                            ),
                            label: Text(
                              "الأقسام والمواد",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    //spacing: AppSizes.s8,
                    children: [
                      // View Like Student Preview Action
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton.icon(
                            onPressed: onPreviewAsStudent,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 16,
                            ),
                            label: Text(
                              "معاينة كطالب",
                              style: AppTextStyles.label.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),
                      // Channel Action
                      Tooltip(
                        message: "قناة الأسئلة",
                        child: InkWell(
                          onTap: onOpenChannel,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primary200),
                            ),
                            child: const Icon(
                              Icons.forum_outlined,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: OutlinedButton.icon(
                            onPressed: onDeleteClassroom,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              backgroundColor: AppColors.error,
                              side: const BorderSide(
                                color: AppColors.error,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: AppColors.surface,
                            ),
                            label: Text(
                              "مسح الفصل",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.surface,
                                fontWeight: FontWeight.w700,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty State
// ---------------------------------------------------------------------------
class _EmptyClassroomsState extends StatelessWidget {
  final bool hasFilter;
  final VoidCallback? onCreate;
  final VoidCallback? onClearFilter;

  const _EmptyClassroomsState({
    required this.hasFilter,
    this.onCreate,
    this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary200),
            ),
            child: Icon(
              hasFilter ? Icons.search_off_rounded : Icons.school_outlined,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hasFilter
                ? "لا توجد فصول مطابقة لخيارات البحث"
                : "لم تقم بإنشاء أي فصول دراسية بعد",
            style: AppTextStyles.h5.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            hasFilter
                ? "جرب البحث بكلمات أخرى أو قم بإلغاء الفلتر."
                : "ابدأ بإنشاء فصل دراسي جديد لرفع المحتوى وإضافة الطلاب.",
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (hasFilter && onClearFilter != null)
            ElevatedButton.icon(
              onPressed: onClearFilter,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
              label: const Text("عرض جميع الفصول"),
            )
          else if (onCreate != null)
            ElevatedButton.icon(
              onPressed: onCreate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text("إنشاء أول فصل الآن"),
            ),
        ],
      ),
    );
  }
}

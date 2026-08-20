import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_extensions.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_state.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_students_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class ClassroomsPage extends StatefulWidget {
  const ClassroomsPage({super.key});

  @override
  State<ClassroomsPage> createState() => _ClassroomsPageState();
}

class _ClassroomsPageState extends State<ClassroomsPage> {
  late final TextEditingController _searchController;
  String _query = "";

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
    if (_query.isEmpty) return classrooms;
    return classrooms.where((classroom) {
      final searchableText = "${classroom.name} ${classroom.subjectName}"
          .toLowerCase();
      return searchableText.contains(_query.toLowerCase());
    }).toList();
  }

  void _createClassroom() {
    AppNavigator.push(
      context: context,
      path: AppRoutes.createClassroomPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassroomCubit, ClassroomState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == CubitStatus.error,
      listener: (context, state) {
        showDialog<void>(
          context: context,
          builder: (_) => AppErrorDialog(
            apiErrorModel: state.apiErrorModel!,
            onRetry: context.read<ClassroomCubit>().getClassrooms,
          ),
        );
      },
      builder: (context, state) {
        final classrooms = _filteredClassrooms(state.classrooms);
        return Scaffold(
          appBar: const CustomAppBar(title: "الفصول الدراسية"),
          drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: context.read<ClassroomCubit>().getClassrooms,
              child:
                  state.status == CubitStatus.loading &&
                      state.classrooms.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.s24,
                        AppSizes.s24,
                        AppSizes.s24,
                        AppSizes.s40,
                      ),
                      children: [
                        Text(
                          "الفصول الدراسية",
                          textAlign: TextAlign.right,
                          style: context.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSizes.s8),
                        Text(
                          "إدارة الفصول الدراسية ومتابعة أعداد الطلبة المنضمين لكل فصل.",
                          textAlign: TextAlign.right,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: AppColors.foregroundMuted,
                          ),
                        ),
                        const SizedBox(height: AppSizes.s16),
                        AppElevatedButton(
                          onPressed: _createClassroom,
                          label: "إنشاء فصل دراسي جديد",
                          icon: const Icon(Icons.add, size: 18),
                          size: const Size(double.infinity, 40),
                        ),
                        const SizedBox(height: AppSizes.s24),
                        _SearchSummary(
                          controller: _searchController,
                          total: state.classrooms.length,
                          onChanged: (value) => setState(() => _query = value),
                        ),
                        const SizedBox(height: AppSizes.s24),
                        if (classrooms.isEmpty)
                          _EmptyClassrooms(hasQuery: _query.isNotEmpty)
                        else
                          ...classrooms.map(
                            (classroom) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSizes.s16,
                              ),
                              child: _ClassroomCard(
                                classroom: classroom,
                                onView: () => context.push(
                                  AppRoutes.classroomStudentsPage(
                                    classroom.classroomId,
                                  ),
                                  extra: classroom,
                                ),
                              ),
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
}

class _SearchSummary extends StatelessWidget {
  final TextEditingController controller;
  final int total;
  final ValueChanged<String> onChanged;

  const _SearchSummary({
    required this.controller,
    required this.total,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSizes.s16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: AppTextFormField(
            controller: controller,
            hintText: "بحث باسم الفصل الدراسي...",
            prefixIcon: Icons.search,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: AppSizes.s12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("إجمالي الفصول:", style: context.textTheme.labelMedium),
            Text("$total", style: context.textTheme.titleMedium),
          ],
        ),
      ],
    ),
  );
}

class _ClassroomCard extends StatefulWidget {
  final ClassroomModel classroom;
  final VoidCallback onView;
  const _ClassroomCard({required this.classroom, required this.onView});

  @override
  State<_ClassroomCard> createState() => _ClassroomCardState();
}

class _ClassroomCardState extends State<_ClassroomCard> {
  @override
  void initState() {
    super.initState();
    context.read<ClassroomStudentsCubit>().getStudents(
      widget.classroom.classroomId,
    );
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSizes.s24),
    decoration: BoxDecoration(
      color: AppColors.surface,
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: _SubjectChip(label: widget.classroom.subjectName),
              ),
            ),
          ],
        ),
        Text(
          widget.classroom.name,
          textAlign: TextAlign.right,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSizes.s4),
        Text(
          widget.classroom.isActive ? "فصل نشط" : "فصل غير نشط",
          textAlign: TextAlign.right,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.foregroundMuted,
          ),
        ),
        const SizedBox(height: AppSizes.s16),
        Container(
          padding: const EdgeInsets.all(AppSizes.s16),
          decoration: BoxDecoration(
            color: AppColors.backgroundMuted,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.groups_outlined, color: AppColors.primary700),
              const SizedBox(width: AppSizes.s8),
              Text("إجمالي الطلبة", style: context.textTheme.labelMedium),
              const Spacer(),
              Text(
                "${context.watch<ClassroomStudentsCubit>().state.students.length} طالب",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s20),
        AppElevatedButton(
          onPressed: widget.onView,
          label: "عرض الفصل",
          icon: const Icon(Icons.arrow_back, size: 17),
          radius: 8,
          size: const Size(double.infinity, 36),
          verticalPadding: 6,
        ),
      ],
    ),
  );
}

class _SubjectChip extends StatelessWidget {
  final String label;
  const _SubjectChip({required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.s12,
      vertical: AppSizes.s4,
    ),
    decoration: BoxDecoration(
      color: AppColors.primary100,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: context.textTheme.labelMedium?.copyWith(
        color: AppColors.primary700,
      ),
    ),
  );
}

class _EmptyClassrooms extends StatelessWidget {
  final bool hasQuery;
  const _EmptyClassrooms({required this.hasQuery});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSizes.s48),
    child: Column(
      children: [
        const Icon(
          Icons.class_outlined,
          size: AppSizes.s48,
          color: AppColors.primary700,
        ),
        const SizedBox(height: AppSizes.s12),
        Text(
          hasQuery ? "لا توجد فصول مطابقة للبحث" : "لا توجد فصول دراسية بعد",
          style: context.textTheme.titleSmall,
        ),
      ],
    ),
  );
}

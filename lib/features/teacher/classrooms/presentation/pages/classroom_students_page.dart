import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/helpers/app_loading.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/student_roster_item_model.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/delete_classroom_student_use_case.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_students_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_students_state.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

class ClassroomStudentsPage extends StatefulWidget {
  final ClassroomModel classroom;

  const ClassroomStudentsPage({super.key, required this.classroom});

  @override
  State<ClassroomStudentsPage> createState() => _ClassroomStudentsPageState();
}

class _ClassroomStudentsPageState extends State<ClassroomStudentsPage> {
  late final TextEditingController _searchController;
  String _query = "";

  String get _normalizedQuery => _query.trim().toLowerCase();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStudents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() {
    return context.read<ClassroomStudentsCubit>().getStudents(
      widget.classroom.classroomId,
    );
  }

  void _loadInitialStudents() {
    AppLoading.show();
    _loadStudents();
  }

  Future<void> _refreshStudents() {
    return _loadStudents();
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value);
  }

  List<StudentRosterItemModel> _filterStudents({
    required List<StudentRosterItemModel> students,
  }) {
    final query = _normalizedQuery;
    if (query.isEmpty) return students;

    return students
        .where((student) => student.fullName.toLowerCase().contains(query))
        .toList(growable: false);
  }

  void _previewAsStudent() {
    AppNavigator.push(
      context: context,
      path: AppRoutes.studentClassroomMaterialsPage(
        widget.classroom.classroomId,
      ),
      extra: widget.classroom.name,
    );
  }

  Future<void> _deleteClassroomStudent({
    required String classroomId,
    required String studentId,
  }) async {
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
              const Text("حذف الطالب"),
            ],
          ),
          content: Text(
            "هل أنت متأكد من حذف الطالب؟",
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

    await context.read<ClassroomStudentsCubit>().deleteClassroomStudent(
      deleteClassroomStudentUseCaseParams: DeleteClassroomStudentUseCaseParams(
        classroomId: classroomId,
        studentId: studentId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassroomStudentsCubit, ClassroomStudentsState>(
      // listenWhen: (previous, current) =>
      //     previous.getStudentsStatus != current.getStudentsStatus,
      listener: (context, state) {
        if (state.getStudentsStatus == CubitStatus.loading ||
            state.deleteStudentStatus == CubitStatus.loading) {
          AppLoading.show();
        } else if (state.getStudentsStatus == CubitStatus.error) {
          AppLoading.hide();

          final error = state.apiErrorModel;
          if (error == null || !context.mounted) return;

          showDialog<void>(
            context: context,
            builder: (_) => AppErrorDialog(
              apiErrorModel: error,
              onRetry: _loadInitialStudents,
            ),
          );
        } else if (state.deleteStudentStatus == CubitStatus.error) {
          AppLoading.hide();

          AppDialogHelper.display(
            context,
            AppErrorDialog(apiErrorModel: state.apiErrorModel!),
          );
        } else if (state.deleteStudentStatus == CubitStatus.success) {
          AppLoading.hide();

          _loadStudents();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.chemistryBiology,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: const Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "تم مسح الطالب بنجاح",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        } else {
          AppLoading.hide();
        }
      },
      builder: (context, state) {
        final students = _filterStudents(students: state.students);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(title: "تفاصيل الفصل والطلاب"),
          body: SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refreshStudents,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.s16,
                  AppSizes.s16,
                  AppSizes.s16,
                  AppSizes.s36,
                ),
                children: [
                  // Classroom Hero Summary Card
                  _ClassroomDetailsHero(
                    classroom: widget.classroom,
                    numberOfStudents: state.students.length,
                    onManageSections: () {
                      AppNavigator.push(
                        context: context,
                        path: AppRoutes.sectionsPage,
                        extra: widget.classroom,
                      );
                    },
                    onOpenChannel: () {
                      AppNavigator.push(
                        context: context,
                        path: AppRoutes.teacherChannelPage(
                          widget.classroom.classroomId,
                        ),
                        extra: widget.classroom.name,
                      );
                    },
                    onPreviewAsStudent: _previewAsStudent,
                  ),
                  const SizedBox(height: AppSizes.s20),

                  // Students Roster Section Header & Search
                  _StudentsRosterHeader(
                    searchController: _searchController,
                    query: _query,
                    totalCount: state.students.length,
                    filteredCount: students.length,
                    onSearchChanged: _onSearchChanged,
                    onClearSearch: () {
                      _searchController.clear();
                      setState(() => _query = "");
                    },
                  ),
                  const SizedBox(height: AppSizes.s12),

                  // Student List / Empty State
                  if (state.getStudentsStatus == CubitStatus.loading &&
                      state.students.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  else if (state.students.isEmpty)
                    const _EmptyStudentsState(hasQuery: false)
                  else if (students.isEmpty)
                    const _EmptyStudentsState(hasQuery: true)
                  else
                    ...students.asMap().entries.map((entry) {
                      final index = entry.key;
                      final student = entry.value;
                      final card = _StudentCard(
                        student: student,
                        onDeleteClassroomStudent: () {
                          _deleteClassroomStudent(
                            classroomId: widget.classroom.classroomId,
                            studentId: student.studentId,
                          );
                        },
                      );

                      if (index < 8) {
                        return FadeInUp(
                          delay: index * 40,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: AppSizes.s8),
                            child: card,
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.s8),
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
// Classroom Details Hero Card
// ---------------------------------------------------------------------------
class _ClassroomDetailsHero extends StatelessWidget {
  final ClassroomModel classroom;
  final int numberOfStudents;
  final VoidCallback onManageSections;
  final VoidCallback onOpenChannel;
  final VoidCallback onPreviewAsStudent;

  const _ClassroomDetailsHero({
    required this.classroom,
    required this.numberOfStudents,
    required this.onManageSections,
    required this.onOpenChannel,
    required this.onPreviewAsStudent,
  });

  void _copyCode(BuildContext context) {
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Accent Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary800, AppColors.primary600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Subject Chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_stories_rounded,
                              size: 13,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              classroom.subjectName,
                              style: AppTextStyles.label.copyWith(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Active Chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
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
                                    : Colors.white70,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              classroom.isActive ? "نشط" : "غير نشط",
                              style: AppTextStyles.label.copyWith(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    classroom.name,
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            // Key Metrics
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Enrolled Students
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.groups_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "الطلاب المقيدين",
                                  style: AppTextStyles.label.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10.5,
                                  ),
                                ),
                                Text(
                                  "$numberOfStudents طالب",
                                  style: AppTextStyles.label.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Enrollment Code with Copy
                  Expanded(
                    child: InkWell(
                      onTap: () => _copyCode(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.amber.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.key_rounded,
                                color: AppColors.amber,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
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
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.copy_rounded,
                              size: 15,
                              color: AppColors.foregroundMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: AppColors.border, height: 1),

            // Quick Actions Bar
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Manage Sections
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: ElevatedButton.icon(
                        onPressed: onManageSections,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.folder_open_rounded, size: 16),
                        label: Text(
                          "الأقسام والمواد",
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
                  // Questions Channel
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: OutlinedButton.icon(
                        onPressed: onOpenChannel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary300),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 16,
                        ),
                        label: Text(
                          "قناة الأسئلة",
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Preview as Student
                  Tooltip(
                    message: "معاينة كطالب",
                    child: InkWell(
                      onTap: onPreviewAsStudent,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.ai50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.ai300),
                        ),
                        child: const Icon(
                          Icons.visibility_outlined,
                          color: AppColors.ai700,
                          size: 19,
                        ),
                      ),
                    ),
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
// Students Roster Header with Search
// ---------------------------------------------------------------------------
class _StudentsRosterHeader extends StatelessWidget {
  final TextEditingController searchController;
  final String query;
  final int totalCount;
  final int filteredCount;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  const _StudentsRosterHeader({
    required this.searchController,
    required this.query,
    required this.totalCount,
    required this.filteredCount,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              "قائمة طلاب الفصل",
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.primary200),
              ),
              child: Text(
                "$filteredCount طالب",
                style: AppTextStyles.label.copyWith(
                  color: AppColors.primary700,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: "بحث باسم الطالب...",
              hintStyle: AppTextStyles.body.copyWith(
                color: AppColors.textDisabled,
                fontSize: 13,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.primary,
                size: 20,
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
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Student Card Item
// ---------------------------------------------------------------------------
class _StudentCard extends StatelessWidget {
  final StudentRosterItemModel student;
  final VoidCallback onDeleteClassroomStudent;
  static final DateFormat _dateFormat = DateFormat.yMMMd("ar");

  const _StudentCard({
    required this.student,
    required this.onDeleteClassroomStudent,
  });

  @override
  Widget build(BuildContext context) {
    final initial = student.fullName.trim().isNotEmpty
        ? student.fullName.trim().characters.first
        : "ط";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Initials Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary600, AppColors.primary800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "انضم في ${_dateFormat.format(student.enrolledAt)}",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Status Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.chemistryBiology.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              student.status.isNotEmpty ? student.status : "مقيد",
              style: AppTextStyles.label.copyWith(
                color: AppColors.chemistryBiology,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 36,
            child: IconButton(
              onPressed: onDeleteClassroomStudent,
              style: IconButton.styleFrom(
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
              tooltip: "مسح الطالب",
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty State
// ---------------------------------------------------------------------------
class _EmptyStudentsState extends StatelessWidget {
  final bool hasQuery;

  const _EmptyStudentsState({required this.hasQuery});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary200),
            ),
            child: Icon(
              hasQuery
                  ? Icons.person_search_rounded
                  : Icons.people_outline_rounded,
              size: 30,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            hasQuery ? "لا يوجد طلاب يطابقون البحث" : "لا يوجد طلاب منضمين بعد",
            style: AppTextStyles.h5.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            hasQuery
                ? "تأكد من كتابة الاسم بشكل صحيح أو امسح البحث."
                : "شارك كود الانضمام مع طلابك ليتمكنوا من التسجيل في هذا الفصل.",
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_extensions.dart";
import "package:draya_mobile/core/helpers/app_loading.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/app_outlined_button.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/student_roster_item_model.dart";
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

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _loadStudents();
      },
    );
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
    setState(() {
      _query = value;
    });
  }

  List<StudentRosterItemModel> _filterStudents({
    required List<StudentRosterItemModel> students,
  }) {
    final query = _normalizedQuery;

    if (query.isEmpty) {
      return students;
    }

    return students
        .where(
          (student) => student.fullName.toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassroomStudentsCubit, ClassroomStudentsState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, state) {
        if (state.status != CubitStatus.loading) {
          AppLoading.hide();
        }

        if (state.status == CubitStatus.error) {
          final error = state.apiErrorModel;

          if (error == null || !context.mounted) {
            return;
          }

          showDialog<void>(
            context: context,
            builder: (_) => AppErrorDialog(
              apiErrorModel: error,
              onRetry: _loadInitialStudents,
            ),
          );
        }
      },

      builder: (context, state) {
        final students = _filterStudents(students: state.students);

        return Scaffold(
          appBar: const CustomAppBar(title: "قائمة الطلاب"),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _refreshStudents,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.s24,
                  AppSizes.s20,
                  AppSizes.s24,
                  AppSizes.s40,
                ),
                children: [
                  Text(
                    "تفاصيل الفصل الدراسي",
                    textAlign: TextAlign.right,
                    style: context.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSizes.s8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _SubjectChip(
                      label: widget.classroom.subjectName,
                    ),
                  ),
                  const SizedBox(height: AppSizes.s16),
                  _ClassroomSummary(
                    classroom: widget.classroom,
                    numberOfStudents: state.students.length,
                  ),
                  const SizedBox(height: AppSizes.s32),
                  Row(
                    children: [
                      Text(
                        "قائمة طلاب الفصل",
                        style: context.textTheme.headlineSmall,
                      ),
                      const SizedBox(width: AppSizes.s12),
                      _CountChip(count: students.length),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s8),
                  Text(
                    "يمكنك عرض الطلاب المسجلين في هذا الفصل والبحث عنهم.",
                    textAlign: TextAlign.right,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.foregroundMuted,
                    ),
                  ),
                  const SizedBox(height: AppSizes.s16),
                  AppTextFormField(
                    controller: _searchController,
                    hintText: "بحث باسم الطالب...",
                    prefixIcon: Icons.search,
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: AppSizes.s16),
                  if (students.isEmpty)
                    const _EmptyStudents()
                  else
                    ...students.map(
                      (student) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSizes.s12,
                        ),
                        child: _StudentCard(student: student),
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

class _ClassroomSummary extends StatelessWidget {
  final ClassroomModel classroom;
  final int numberOfStudents;
  const _ClassroomSummary({
    required this.classroom,
    required this.numberOfStudents,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSizes.s20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.surface, AppColors.backgroundSecondary],
      ),
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "البيانات الأساسية للفصل",
          textAlign: TextAlign.right,
          style: context.textTheme.labelMedium?.copyWith(
            color: AppColors.foregroundMuted,
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        Text(
          classroom.name,
          textAlign: TextAlign.right,
          style: context.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSizes.s16),
        _SummaryRow(
          icon: Icons.groups_outlined,
          label: "عدد الطلبة المقيدين",
          value: "$numberOfStudents طالب",
        ),
        const SizedBox(height: AppSizes.s12),
        _SummaryRow(
          icon: classroom.isActive
              ? Icons.check_circle_outline
              : Icons.pause_circle_outline,
          label: "حالة الفصل",
          value: classroom.isActive ? "نشط" : "غير نشط",
        ),
        const SizedBox(height: AppSizes.s12),
        _SummaryRow(
          icon: Icons.copy,
          label: "كود الاشتراك",
          value: classroom.enrollmentCode,
          onTap: () async {
            await Clipboard.setData(
              ClipboardData(text: classroom.enrollmentCode),
            );

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم نسخ كود الاشتراك"),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        const SizedBox(height: AppSizes.s12),
        AppElevatedButton(
          onPressed: () {
            AppNavigator.push(
              context: context,
              path: AppRoutes.materialsPage,
              extra: classroom,
            );
          },
          label: "ادارة المواد الدراسية",
        ),
        const SizedBox(height: AppSizes.s12),
        AppOutlinedButton(
          onPressed: () {
            AppNavigator.push(
              context: context,
              path: AppRoutes.teacherChannelPage(
                classroom.classroomId,
              ),
              extra: classroom.name,
            );
          },
          label: "قناة الأسئلة",
        ),
      ],
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.all(AppSizes.s12),
      decoration: BoxDecoration(
        color: AppColors.backgroundMuted,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.s12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary700,
          ),
          const SizedBox(width: AppSizes.s12),
          Expanded(
            child: Text(
              label,
              style: context.textTheme.labelMedium,
            ),
          ),
          Text(
            value,
            style: context.textTheme.labelLarge,
          ),
        ],
      ),
    );

    if (onTap == null) {
      return child;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.s12),
      child: child,
    );
  }
}

class _StudentCard extends StatelessWidget {
  final StudentRosterItemModel student;
  static final DateFormat _dateFormat = DateFormat.yMMMd("ar");

  const _StudentCard({required this.student});

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
        CircleAvatar(
          backgroundColor: AppColors.primary100,
          foregroundColor: AppColors.primary700,
          child: Text(student.fullName.isEmpty ? "?" : student.fullName[0]),
        ),
        const SizedBox(width: AppSizes.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(student.fullName, style: context.textTheme.titleSmall),
              Text(
                "انضم في ${_dateFormat.format(student.enrolledAt)}",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.foregroundMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.s8),
        _StatusChip(status: student.status),
      ],
    ),
  );
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.s8,
      vertical: AppSizes.s4,
    ),
    decoration: BoxDecoration(
      color: AppColors.primary100,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      status,
      style: context.textTheme.labelMedium?.copyWith(
        color: AppColors.primary700,
      ),
    ),
  );
}

class _CountChip extends StatelessWidget {
  final int count;
  const _CountChip({required this.count});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.s12,
      vertical: AppSizes.s4,
    ),
    decoration: BoxDecoration(
      color: AppColors.mathPhysics.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      "$count طلاب",
      style: context.textTheme.labelMedium?.copyWith(
        color: AppColors.mathPhysics,
      ),
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

class _EmptyStudents extends StatelessWidget {
  const _EmptyStudents();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s48),
      child: Column(
        children: [
          const Icon(
            Icons.people_outline,
            size: AppSizes.s48,
            color: AppColors.primary700,
          ),
          const SizedBox(height: AppSizes.s12),
          Text(
            "لا يوجد طلاب",
            style: context.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

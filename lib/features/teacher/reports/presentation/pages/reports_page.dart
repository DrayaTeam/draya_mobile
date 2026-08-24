import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_state.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_students_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_students_state.dart";
import "package:draya_mobile/features/teacher/reports/data/models/performance_report_model.dart";
import "package:draya_mobile/features/teacher/reports/presentation/cubit/reports_cubit.dart";
import "package:draya_mobile/features/teacher/reports/presentation/cubit/reports_state.dart";
import "package:draya_mobile/features/teacher/reports/presentation/pages/widgets/expandable_student_section.dart";
import "package:draya_mobile/features/teacher/reports/presentation/pages/widgets/report_loading_placeholder.dart";
import "package:draya_mobile/features/teacher/reports/presentation/pages/widgets/report_stats_grid.dart";
import "package:draya_mobile/features/teacher/reports/presentation/pages/widgets/report_summary_header.dart";
import "package:draya_mobile/features/teacher/reports/presentation/pages/widgets/subject_proficiency_chart.dart";
import "package:draya_mobile/features/teacher/reports/presentation/pages/widgets/weak_topics_list.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String? _selectedClassroomId;

  final Set<String> _expandedStudentIds = {};

  static final DateFormat _dateFormat = DateFormat.yMMMd("ar");

  @override
  void initState() {
    super.initState();

    context.read<ClassroomCubit>().getClassrooms();
  }

  void _onClassroomChanged(
    String? classroomId,
  ) {
    if (classroomId == null) return;

    setState(() {
      _selectedClassroomId = classroomId;
      _expandedStudentIds.clear();
    });

    context.read<ReportsCubit>().clearReports();

    context.read<ClassroomStudentsCubit>().getStudents(classroomId);
  }

  void _toggleStudent({
    required String studentId,
  }) {
    final isExpanded = _expandedStudentIds.contains(studentId);

    setState(() {
      if (isExpanded) {
        _expandedStudentIds.remove(studentId);
      } else {
        _expandedStudentIds.add(studentId);
      }
    });

    if (!isExpanded) {
      context.read<ReportsCubit>().getPerformanceReport(
        studentId: studentId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "التقارير",
      ),
      drawer: AppDrawer(
        drawerItemsList: getTeacherDrawerItemsList(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeroHeader(),

              const SizedBox(height: AppSizes.s16),

              BlocBuilder<ClassroomCubit, ClassroomState>(
                builder: (context, state) {
                  switch (state.status) {
                    case CubitStatus.success:
                      if (state.classrooms.isEmpty) {
                        return _buildNoClassroomsMessage();
                      }
                      return _buildClassroomPills(state.classrooms);

                    case CubitStatus.error:
                      return _buildErrorState(
                        message: "حدث خطأ عند استرجاع الفصول الدراسية",
                        onRetry: () {
                          context.read<ClassroomCubit>().getClassrooms();
                        },
                      );

                    default:
                      return const SizedBox(
                        height: 44,
                        child: Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                        ),
                      );
                  }
                },
              ),

              const SizedBox(height: AppSizes.s16),

              if (_selectedClassroomId == null)
                _buildSelectClassroomMessage()
              else
                BlocBuilder<ClassroomStudentsCubit, ClassroomStudentsState>(
                  builder: (context, studentsState) {
                    if (studentsState.getStudentsStatus ==
                        CubitStatus.loading) {
                      return const ReportLoadingPlaceholder();
                    }

                    if (studentsState.getStudentsStatus == CubitStatus.error) {
                      return _buildErrorState(
                        message: "حدث خطأ عند استرجاع طلاب الفصل",
                        onRetry: () {
                          context.read<ClassroomStudentsCubit>().getStudents(
                            _selectedClassroomId!,
                          );
                        },
                      );
                    }

                    if (studentsState.students.isEmpty) {
                      return _buildEmptyStudentsMessage();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.primary600,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            const SizedBox(width: AppSizes.s8),
                            Text(
                              "الطلاب (${studentsState.students.length})",
                              style: AppTextStyles.h3.copyWith(fontSize: 17),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSizes.s12),

                        BlocBuilder<ReportsCubit, ReportsState>(
                          builder: (context, reportsState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: studentsState.students.map((student) {
                                final studentId = student.studentId;

                                final isExpanded = _expandedStudentIds.contains(
                                  studentId,
                                );

                                final report =
                                    reportsState.reportsByStudentId[studentId];

                                final isLoading = reportsState.loadingStudentIds
                                    .contains(studentId);

                                final error =
                                    reportsState.errorsByStudentId[studentId];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSizes.s12,
                                  ),
                                  child: ExpandableStudentSection(
                                    title: student.fullName,
                                    subtitle:
                                        "انضم في ${_dateFormat.format(student.enrolledAt)}",
                                    label: student.status.isNotEmpty
                                        ? student.status
                                        : "مقيد",
                                    color: AppColors.primary,
                                    profileImageUrl: student.profilePictureUrl,
                                    isExpanded: isExpanded,
                                    onToggle: () {
                                      _toggleStudent(
                                        studentId: studentId,
                                      );
                                    },
                                    children: [
                                      _buildStudentReport(
                                        report: report,
                                        isLoading: isLoading,
                                        hasError: error != null,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassroomPills(List<ClassroomModel> classrooms) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: classrooms.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSizes.s8),
        itemBuilder: (context, index) {
          final classroom = classrooms[index];
          final isSelected = _selectedClassroomId == classroom.classroomId;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: InkWell(
              onTap: () => _onClassroomChanged(classroom.classroomId),
              borderRadius: BorderRadius.circular(999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary700 : AppColors.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary700
                        : AppColors.borderStrong,
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary700.withValues(alpha: 0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.class_outlined,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSizes.s6),
                    Text(
                      classroom.name,
                      style: AppTextStyles.label.copyWith(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSizes.s6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s8,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : AppColors.backgroundMuted,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        "${classroom.studentCount}",
                        style: AppTextStyles.label.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
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

  Widget _buildHeroHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.primary800, AppColors.primary500],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary700.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "متابعة أداء الطلاب",
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                    fontSize: 21,
                  ),
                ),
                const SizedBox(height: AppSizes.s6),
                Text(
                  "تابع مستوى طلابك في كل فصل دراسي من مكان واحد",
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.s12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.insights_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectClassroomMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s40),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.primary100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_outlined,
              color: AppColors.primary600,
              size: 34,
            ),
          ),
          const SizedBox(height: AppSizes.s16),
          Text(
            "اختر الفصل الدراسي لعرض الطلاب",
            style: AppTextStyles.body.copyWith(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoClassroomsMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s24),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.backgroundMuted,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.meeting_room_outlined,
              color: AppColors.textDisabled,
              size: 30,
            ),
          ),
          const SizedBox(height: AppSizes.s12),
          Text(
            "لا توجد فصول دراسية بعد",
            style: AppTextStyles.body.copyWith(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStudentsMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s40),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.backgroundMuted,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.group_off_outlined,
              color: AppColors.textDisabled,
              size: 34,
            ),
          ),
          const SizedBox(height: AppSizes.s16),
          Text(
            "لا يوجد طلاب في هذا الفصل",
            style: AppTextStyles.body.copyWith(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.s24),
        child: Column(
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
                color: AppColors.error,
                size: 30,
              ),
            ),
            const SizedBox(height: AppSizes.s12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.s12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text("إعادة المحاولة"),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary700,
                textStyle: AppTextStyles.button.copyWith(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primary100,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: AppColors.primary700, size: 16),
        ),
        const SizedBox(width: AppSizes.s8),
        Text(
          title,
          style: AppTextStyles.h3.copyWith(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildStudentReport({
    required PerformanceReportModel? report,
    required bool isLoading,
    required bool hasError,
  }) {
    if (isLoading) {
      return const ReportLoadingPlaceholder();
    }

    if (hasError) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.s16),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 22,
            ),
            const SizedBox(width: AppSizes.s10),
            Expanded(
              child: Text(
                "حدث خطأ عند استرجاع تقرير الطالب",
                style: AppTextStyles.body.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (report == null) {
      return Text(
        "لا يوجد تقرير متاح لهذا الطالب",
        style: AppTextStyles.body.copyWith(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReportSummaryHeader(
          summaryText: report.summaryText,
          percentile: report.classroomPercentile,
          generatedAt: report.generatedAt,
        ),

        const SizedBox(height: AppSizes.s12),

        ReportStatsGrid(report: report),

        if (report.subjectProficiencies.isNotEmpty) ...[
          const SizedBox(height: AppSizes.s16),
          _buildSectionTitle(
            icon: Icons.bar_chart_rounded,
            title: "مستوى المواد",
          ),
          const SizedBox(height: AppSizes.s10),
          SubjectProficiencyChart(subjects: report.subjectProficiencies),
        ],

        if (report.weakTopics.isNotEmpty) ...[
          const SizedBox(height: AppSizes.s16),
          _buildSectionTitle(
            icon: Icons.flag_rounded,
            title: "نقاط الضعف",
          ),
          const SizedBox(height: AppSizes.s10),
          WeakTopicsList(topics: report.weakTopics),
        ],

        BlocConsumer<ReportsCubit, ReportsState>(
          listener: (BuildContext context, ReportsState state) {
            switch (state.approveReportStatus) {
              case CubitStatus.success:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("تم ارسال التقرير"),
                  ),
                );
                break;
              case CubitStatus.error:
                AppDialogHelper.display(
                  context,
                  AppErrorDialog(apiErrorModel: state.apiErrorModel!),
                );
                break;
              default:
                break;
            }
          },
          builder: (BuildContext context, ReportsState state) {
            return AppElevatedButton(
              onPressed: () {
                context.read<ReportsCubit>().approveReport(
                  reportId: report.id,
                );
              },
              label: state.approveReportStatus == CubitStatus.loading
                  ? "جار الارسال..."
                  : "ارسال التقرير الى اولياء الامور",
            );
          },
        ),
      ],
    );
  }
}

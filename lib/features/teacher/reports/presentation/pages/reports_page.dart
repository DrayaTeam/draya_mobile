import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_extensions.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_drop_down_form_field.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_state.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_students_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_students_state.dart";
import "package:draya_mobile/features/teacher/reports/data/models/performance_report_model.dart";
import "package:draya_mobile/features/teacher/reports/presentation/cubit/reports_cubit.dart";
import "package:draya_mobile/features/teacher/reports/presentation/cubit/reports_state.dart";
import "package:draya_mobile/features/teacher/reports/presentation/pages/widgets/expandable_student_section.dart";
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
              Text(
                "متابعة اداء الطلاب فى كل فصل",
                style: context.textTheme.headlineMedium,
              ),

              const SizedBox(height: AppSizes.s20),

              BlocBuilder<ClassroomCubit, ClassroomState>(
                builder: (context, state) {
                  switch (state.status) {
                    case CubitStatus.success:
                      return AppDropDownFormField(
                        hint: "اختر الفصل الدراسي",
                        value: _selectedClassroomId,
                        dropDownItems: state.classrooms.map((classroom) {
                          return DropdownMenuItem<String>(
                            value: classroom.classroomId,
                            child: Text(classroom.name),
                          );
                        }).toList(),
                        onChanged: _onClassroomChanged,
                      );

                    case CubitStatus.error:
                      return Center(
                        child: Text(
                          "حدث خطأ عند استرجاع الفصول الدراسية",
                          style: context.textTheme.headlineLarge?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      );

                    default:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                },
              ),

              const SizedBox(height: AppSizes.s12),
              const Divider(),
              const SizedBox(height: AppSizes.s12),

              if (_selectedClassroomId == null)
                _buildSelectClassroomMessage()
              else
                BlocBuilder<ClassroomStudentsCubit, ClassroomStudentsState>(
                  builder: (context, studentsState) {
                    if (studentsState.status == CubitStatus.loading) {
                      return const Padding(
                        padding: EdgeInsets.all(AppSizes.s32),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (studentsState.status == CubitStatus.error) {
                      return Center(
                        child: Text(
                          "حدث خطأ عند استرجاع طلاب الفصل",
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      );
                    }

                    if (studentsState.students.isEmpty) {
                      return _buildEmptyStudentsMessage();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "الطلاب (${studentsState.students.length})",
                          style: context.textTheme.titleLarge,
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
                                    icon: Icons.person_outline_rounded,
                                    color: AppColors.primary,
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

  Widget _buildSelectClassroomMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          "اختر الفصل الدراسي لعرض الطلاب",
          style: context.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStudentsMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s40),
      child: Center(
        child: Text(
          "لا يوجد طلاب في هذا الفصل",
          style: context.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentReport({
    required PerformanceReportModel? report,
    required bool isLoading,
    required bool hasError,
  }) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (hasError) {
      return Text(
        "حدث خطأ عند استرجاع تقرير الطالب",
        style: context.textTheme.bodyMedium?.copyWith(
          color: AppColors.error,
        ),
      );
    }

    if (report == null) {
      return Text(
        "لا يوجد تقرير متاح لهذا الطالب",
        style: context.textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildReportItem(
          title: "ملخص الأداء",
          value: report.summaryText,
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildReportItem(
                title: "الأسئلة",
                value: "${report.totalQuestionsAsked}",
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildReportItem(
                title: "الدروس المكتملة",
                value: report.completedLessons.toString(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _buildReportItem(
                title: "مدة الاختبار",
                value:
                    "${report.averageExamDurationMinutes.toStringAsFixed(1)} دقيقة",
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildReportItem(
                title: "ترتيب الفصل",
                value: "${report.classroomPercentile.toStringAsFixed(1)}%",
              ),
            ),
          ],
        ),

        if (report.subjectProficiencies.isNotEmpty) ...[
          const SizedBox(height: 16),

          Text(
            "مستوى المواد",
            style: context.textTheme.titleMedium,
          ),

          const SizedBox(height: 8),

          ...report.subjectProficiencies.map(
            (subject) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(subject.subjectName),
                    ),
                    Text(
                      "${subject.proficiencyPercent.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],

        if (report.weakTopics.isNotEmpty) ...[
          const SizedBox(height: 16),

          Text(
            "نقاط الضعف",
            style: context.textTheme.titleMedium,
          ),

          const SizedBox(height: 8),

          ...report.weakTopics.map(
            (topic) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      topic.topicName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      topic.recommendation,
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildReportItem({
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import "dart:async";

import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:draya_mobile/features/student/exams/domain/usecases/get_student_exams_use_case.dart";
import "package:draya_mobile/features/student/exams/presentation/widgets/exam_card_item.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/entity/student_enrolled_classroom.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/presentation/cubit/student_enrolled_classrooms_cubit.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/presentation/cubit/student_enrolled_classrooms_state.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/classroom_section.dart";
import "package:draya_mobile/features/student/student_materials/domain/usecases/get_classroom_sections_use_case.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class _ClassroomExamItem {
  final SectionExam exam;
  final String classroomId;
  final String classroomName;
  final String sectionTitle;
  final StudentExamOverview? overview;

  const _ClassroomExamItem({
    required this.exam,
    required this.classroomId,
    required this.classroomName,
    required this.sectionTitle,
    this.overview,
  });
}

class StudentExamsBody extends StatefulWidget {
  const StudentExamsBody({super.key});

  @override
  State<StudentExamsBody> createState() => _StudentExamsBodyState();
}

class _StudentExamsBodyState extends State<StudentExamsBody> {
  String? _selectedClassroomId;
  bool _isLoadingSections = false;
  List<_ClassroomExamItem> _allExams = [];
  final Map<String, StudentExamOverview> _overviewsById = {};

  @override
  void initState() {
    super.initState();
    context
        .read<StudentEnrolledClassroomsCubit>()
        .getStudentEnrolledClassrooms();
  }

  Future<void> _loadExamsForClassrooms(
    List<StudentEnrolledClassroom> classrooms,
  ) async {
    if (_isLoadingSections) return;
    setState(() {
      _isLoadingSections = true;
    });

    final getSectionsUseCase = getIt<GetClassroomSectionsUseCase>();
    final collected = <_ClassroomExamItem>[];

    // Load the student's exam overviews (attempts info) in parallel
    unawaited(_loadExamOverviews());

    for (final classroom in classrooms) {
      final result = await getSectionsUseCase.call(
        params: classroom.classroomId,
      );
      if (result is Success<List<ClassroomSection>>) {
        for (final section in result.data) {
          for (final exam in section.exams) {
            collected.add(
              _ClassroomExamItem(
                exam: exam,
                classroomId: classroom.classroomId,
                classroomName: classroom.name,
                sectionTitle: section.title,
                overview: _overviewsById[exam.id],
              ),
            );
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _allExams = collected;
        _isLoadingSections = false;
      });
    }
  }

  Future<void> _loadExamOverviews() async {
    final result = await getIt<GetStudentExamsUseCase>().call();
    if (result is Success<List<StudentExamOverview>> && mounted) {
      setState(() {
        _overviewsById
          ..clear()
          ..addEntries(result.data.map((e) => MapEntry(e.id, e)));
        _allExams = [
          for (final item in _allExams)
            _ClassroomExamItem(
              exam: item.exam,
              classroomId: item.classroomId,
              classroomName: item.classroomName,
              sectionTitle: item.sectionTitle,
              overview: _overviewsById[item.exam.id],
            ),
        ];
      });
    }
  }

  void _onStartExam(_ClassroomExamItem item) {
    AppNavigator.push(
      context: context,
      path: AppRoutes.studentExamDetailsPage,
      extra: {
        "examId": item.exam.id,
        "classroomName": item.classroomName,
      },
    );
  }

  void _onViewResult(_ClassroomExamItem item) {
    final attemptId = item.overview?.latestAttempt?.id;
    if (attemptId == null || attemptId.isEmpty) return;
    AppNavigator.push(
      context: context,
      path: AppRoutes.studentExamDetailsPage,
      extra: {
        "examId": item.exam.id,
        "classroomName": item.classroomName,
        "attemptId": attemptId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      StudentEnrolledClassroomsCubit,
      StudentEnrolledClassroomsState
    >(
      listener: (context, state) {
        if (state.status == CubitStatus.success &&
            state.classrooms.isNotEmpty) {
          _loadExamsForClassrooms(state.classrooms);
        }
      },
      builder: (context, state) {
        if (state.status == CubitStatus.loading && state.classrooms.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final filteredExams = _selectedClassroomId == null
            ? _allExams
            : _allExams
                  .where((e) => e.classroomId == _selectedClassroomId)
                  .toList();

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await context
                .read<StudentEnrolledClassroomsCubit>()
                .getStudentEnrolledClassrooms();
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.s16),
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(AppSizes.s16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s12,
                        vertical: AppSizes.s4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.solidStar,
                            color: AppColors.amber,
                            size: 12,
                          ),
                          const SizedBox(width: AppSizes.s4),
                          Text(
                            "مركز التقويم والاختبارات التفاعلية",
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.primary700,
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.s12),
                    Text(
                      "الامتحانات والاختبارات المتاحة",
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      "استعرض الاختبارات المتاحة في فصولك الدراسية مع تصحيح فوري وتحليل بالذكاء الاصطناعي.",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.s16),

              // Classroom selector chips if multiple classrooms
              if (state.classrooms.isNotEmpty) ...[
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ChoiceChip(
                          label: Text(
                            "جميع الفصول (${_allExams.length})",
                            style: AppTextStyles.label.copyWith(
                              color: _selectedClassroomId == null
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          selected: _selectedClassroomId == null,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surface,
                          checkmarkColor: Colors.white,
                          side: BorderSide(
                            color: _selectedClassroomId == null
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                          onSelected: (_) {
                            setState(() {
                              _selectedClassroomId = null;
                            });
                          },
                        ),
                      ),
                      ...state.classrooms.map((c) {
                        final isSelected =
                            _selectedClassroomId == c.classroomId;
                        final count = _allExams
                            .where((e) => e.classroomId == c.classroomId)
                            .length;
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: ChoiceChip(
                            label: Text(
                              "${c.name} ($count)",
                              style: AppTextStyles.label.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surface,
                            checkmarkColor: Colors.white,
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                            onSelected: (_) {
                              setState(() {
                                _selectedClassroomId = c.classroomId;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.s16),
              ],

              // Loading or Exam list
              if (_isLoadingSections && _allExams.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                )
              else if (filteredExams.isEmpty)
                _buildEmptyState()
              else
                ...filteredExams.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  final card = ExamCardItem(
                    exam: item.exam,
                    classroomName: item.classroomName,
                    sectionTitle: item.sectionTitle,
                    overview: item.overview,
                    onStart: () => _onStartExam(item),
                    onViewResult: () => _onViewResult(item),
                  );

                  if (index < 6) {
                    return FadeInUp(
                      delay: index * 50,
                      child: card,
                    );
                  }
                  return card;
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.amber.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.quiz_outlined,
                size: 40,
                color: AppColors.amber,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "لا توجد امتحانات متاحة حالياً",
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "ستظهر هنا الامتحانات التي يضيفها معلموك في أقسام الفصول الدراسية.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

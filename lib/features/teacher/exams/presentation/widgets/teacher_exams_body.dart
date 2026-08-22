import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_state.dart";
import "package:draya_mobile/features/teacher/exams/presentation/widgets/teacher_exam_card_item.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_exam_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";
import "package:draya_mobile/features/teacher/sections/domain/usecases/get_sections_use_case.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class _TeacherExamItem {
  final SectionExamModel exam;
  final String classroomId;
  final String classroomName;
  final String sectionTitle;

  const _TeacherExamItem({
    required this.exam,
    required this.classroomId,
    required this.classroomName,
    required this.sectionTitle,
  });
}

class TeacherExamsBody extends StatefulWidget {
  const TeacherExamsBody({super.key});

  @override
  State<TeacherExamsBody> createState() => _TeacherExamsBodyState();
}

class _TeacherExamsBodyState extends State<TeacherExamsBody> {
  String? _selectedClassroomId;
  bool _isLoadingSections = false;
  bool _hasLoadError = false;
  List<_TeacherExamItem> _allExams = [];

  @override
  void initState() {
    super.initState();
    context.read<ClassroomCubit>().getClassrooms();
  }

  Future<void> _loadExamsForClassrooms(List<ClassroomModel> classrooms) async {
    if (_isLoadingSections) return;
    setState(() {
      _isLoadingSections = true;
      _hasLoadError = false;
    });

    final getSectionsUseCase = getIt<GetSectionsUseCase>();
    final collected = <_TeacherExamItem>[];
    var hadError = false;

    for (final classroom in classrooms) {
      final result =
          await getSectionsUseCase.call(params: classroom.classroomId);
      if (result is Success<List<SectionModel>>) {
        for (final section in result.data) {
          for (final exam in section.exams) {
            collected.add(
              _TeacherExamItem(
                exam: exam,
                classroomId: classroom.classroomId,
                classroomName: classroom.name,
                sectionTitle: section.title,
              ),
            );
          }
        }
      } else {
        hadError = true;
      }
    }

    collected.sort((a, b) => b.exam.createdAt.compareTo(a.exam.createdAt));

    if (mounted) {
      setState(() {
        _allExams = collected;
        _isLoadingSections = false;
        _hasLoadError = hadError && collected.isEmpty;
      });
    }
  }

  void _onGenerateExam() {
    HapticFeedback.lightImpact();
    AppNavigator.push(
      context: context,
      path: AppRoutes.examGenerationPage1,
    );
  }

  void _onViewQuestions(_TeacherExamItem item) {
    HapticFeedback.lightImpact();
    AppNavigator.push(
      context: context,
      path: AppRoutes.teacherExamQuestionsPage,
      extra: {
        "examId": item.exam.id,
        "classroomName": item.classroomName,
        "sectionTitle": item.sectionTitle,
      },
    );
  }

  Future<void> _onRefresh() async {
    await context.read<ClassroomCubit>().getClassrooms();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassroomCubit, ClassroomState>(
      listener: (context, state) {
        if (state.status == CubitStatus.success && state.classrooms.isNotEmpty) {
          _loadExamsForClassrooms(state.classrooms);
        }
        if (state.status == CubitStatus.success && state.classrooms.isEmpty) {
          setState(() {
            _allExams = [];
            _isLoadingSections = false;
          });
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

        final activeCount = _allExams
            .where((e) => _resolveStatus(e.exam) == ExamAccessStatus.active)
            .length;
        final upcomingCount = _allExams
            .where((e) => _resolveStatus(e.exam) == ExamAccessStatus.upcoming)
            .length;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _onRefresh,
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.all(AppSizes.s16),
            children: [
              _buildHeaderCard(),
              const SizedBox(height: AppSizes.s16),

              if (_allExams.isNotEmpty) ...[
                _buildStatsRow(activeCount, upcomingCount),
                const SizedBox(height: AppSizes.s16),
              ],

              if (state.classrooms.length > 1) ...[
                _buildClassroomFilters(state.classrooms),
                const SizedBox(height: AppSizes.s16),
              ],

              if (_isLoadingSections && _allExams.isEmpty)
                _buildListLoading()
              else if (_hasLoadError)
                _buildErrorState()
              else if (filteredExams.isEmpty)
                _buildEmptyState()
              else
                ...filteredExams.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  final card = TeacherExamCardItem(
                    exam: item.exam,
                    classroomName: item.classroomName,
                    sectionTitle: item.sectionTitle,
                    onViewQuestions: () => _onViewQuestions(item),
                  );

                  if (index < 6) {
                    return FadeInUp(
                      delay: index * 60,
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

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.04),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
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
              color: AppColors.ai50,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.ai100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(
                  FontAwesomeIcons.wandMagicSparkles,
                  color: AppColors.ai700,
                  size: 12,
                ),
                const SizedBox(width: AppSizes.s4),
                Text(
                  "مدعوم بالذكاء الاصطناعي",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.ai700,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.s12),
          Text(
            "إدارة امتحانات فصولك الدراسية",
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSizes.s4),
          Text(
            "استعرض جميع الامتحانات التي أنشأتها في أقسام فصولك، وتصفح أسئلتها وإجاباتها الصحيحة، أو أنشئ امتحاناً جديداً بالذكاء الاصطناعي.",
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSizes.s16),
          _buildGenerateButton(),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onGenerateExam,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary700, AppColors.primary500],
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.28),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.fileCirclePlus,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "إنشاء امتحان جديد",
                style: AppTextStyles.button.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(int activeCount, int upcomingCount) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.assignment_outlined,
            label: "إجمالي الامتحانات",
            value: "${_allExams.length}",
            color: AppColors.primary,
            bgColor: AppColors.primary50,
          ),
        ),
        const SizedBox(width: AppSizes.s8),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_outline_rounded,
            label: "متاح الآن",
            value: "$activeCount",
            color: AppColors.chemistryBiology,
            bgColor: AppColors.chemistryBiology.withValues(alpha: 0.1),
          ),
        ),
        const SizedBox(width: AppSizes.s8),
        Expanded(
          child: _buildStatCard(
            icon: Icons.schedule_rounded,
            label: "قادمة",
            value: "$upcomingCount",
            color: AppColors.mathPhysics,
            bgColor: AppColors.mathPhysics.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassroomFilters(List<ClassroomModel> classrooms) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
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
          ...classrooms.map((c) {
            final isSelected = _selectedClassroomId == c.classroomId;
            final count = _allExams
                .where((e) => e.classroomId == c.classroomId)
                .length;
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ChoiceChip(
                label: Text(
                  "${c.name} ($count)",
                  style: AppTextStyles.label.copyWith(
                    color:
                        isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
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
    );
  }

  Widget _buildListLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  ExamAccessStatus _resolveStatus(SectionExamModel exam) {
    final now = DateTime.now().toUtc();
    if (exam.startDate != null && now.isBefore(exam.startDate!.toUtc())) {
      return ExamAccessStatus.upcoming;
    }
    if (exam.endDate != null && now.isAfter(exam.endDate!.toUtc())) {
      return ExamAccessStatus.expired;
    }
    return ExamAccessStatus.active;
  }

  Widget _buildEmptyState() {
    final hasNoClassrooms = context.read<ClassroomCubit>().state.classrooms.isEmpty;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.quiz_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hasNoClassrooms
                  ? "لا توجد فصول دراسية بعد"
                  : "لا توجد امتحانات بعد",
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hasNoClassrooms
                  ? "أنشئ فصلك الدراسي الأول ثم أضف أقساماً وابدأ بإنشاء الامتحانات."
                  : "ابدأ بإنشاء امتحانك الأول بالذكاء الاصطناعي وسيظهر هنا مع أسئلته وإجاباته.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(height: 16),
            if (!hasNoClassrooms) _buildGenerateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "حدث خطأ أثناء تحميل الامتحانات",
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "تأكد من اتصالك بالإنترنت وحاول مرة أخرى.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _onRefresh,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary700,
                side: const BorderSide(color: AppColors.primary300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text("إعادة المحاولة"),
            ),
          ],
        ),
      ),
    );
  }
}

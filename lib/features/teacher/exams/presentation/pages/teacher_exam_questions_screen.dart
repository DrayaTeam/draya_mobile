import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/source/teacher_exam_remote_data_source.dart";
import "package:draya_mobile/features/teacher/exams/presentation/widgets/teacher_exam_question_view_card.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

enum _LoadStatus { loading, success, error }

class TeacherExamQuestionsScreen extends StatefulWidget {
  final String examId;
  final String? classroomName;
  final String? sectionTitle;

  const TeacherExamQuestionsScreen({
    super.key,
    required this.examId,
    this.classroomName,
    this.sectionTitle,
  });

  @override
  State<TeacherExamQuestionsScreen> createState() =>
      _TeacherExamQuestionsScreenState();
}

class _TeacherExamQuestionsScreenState
    extends State<TeacherExamQuestionsScreen> {
  _LoadStatus _status = _LoadStatus.loading;
  TeacherExamDetailModel? _exam;

  @override
  void initState() {
    super.initState();
    _loadExam();
  }

  Future<void> _loadExam() async {
    setState(() {
      _status = _LoadStatus.loading;
    });
    try {
      final remote = getIt<TeacherExamRemoteDataSource>();
      final exam = await remote.getExamDetails(widget.examId);
      if (mounted) {
        setState(() {
          _exam = exam;
          _status = _LoadStatus.success;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _status = _LoadStatus.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "أسئلة الامتحان"),
      body: switch (_status) {
        _LoadStatus.loading => _buildLoading(),
        _LoadStatus.error => _buildError(),
        _LoadStatus.success => _buildSuccess(),
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              "حدث خطأ أثناء تحميل الأسئلة",
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
              onPressed: _loadExam,
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

  Widget _buildSuccess() {
    final exam = _exam!;
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadExam,
      child: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.all(AppSizes.s16),
        children: [
          FadeInUp(child: _buildSummaryCard(exam)),
          const SizedBox(height: AppSizes.s20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s4),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "الأسئلة والإجابات الصحيحة (${exam.questions.length})",
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.s12),
          ...exam.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;

            final card = TeacherExamQuestionViewCard(
              question: question,
              index: index,
            );

            if (index < 8) {
              return FadeInUp(
                delay: 100 + index * 60,
                child: card,
              );
            }
            return card;
          }),
          const SizedBox(height: AppSizes.s24),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(TeacherExamDetailModel exam) {
    final dateFormat = DateFormat("d MMM yyyy", "ar");
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary800, AppColors.primary600],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 18,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.school_outlined,
                      size: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        widget.classroomName ?? "فصل دراسي",
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.sectionTitle != null &&
                  widget.sectionTitle!.isNotEmpty) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.folder_outlined,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.sectionTitle!,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSizes.s12),
          Text(
            exam.topic,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 19,
            ),
          ),
          if (exam.title.isNotEmpty && exam.title != exam.topic) ...[
            const SizedBox(height: 2),
            Text(
              exam.title,
              style: AppTextStyles.body.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: AppSizes.s14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMetaChip(
                icon: Icons.quiz_outlined,
                text: "${exam.questions.length} سؤال",
              ),
              if (exam.durationMinutes != null && exam.durationMinutes! > 0)
                _buildMetaChip(
                  icon: Icons.timer_outlined,
                  text: "${exam.durationMinutes} دقيقة",
                ),
              if (exam.allowedAttempts != null && exam.allowedAttempts! > 0)
                _buildMetaChip(
                  icon: Icons.replay_rounded,
                  text: "${exam.allowedAttempts} محاولات",
                ),
              if (exam.createdAt != null)
                _buildMetaChip(
                  icon: Icons.calendar_today_outlined,
                  text: dateFormat.format(exam.createdAt!),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.label.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

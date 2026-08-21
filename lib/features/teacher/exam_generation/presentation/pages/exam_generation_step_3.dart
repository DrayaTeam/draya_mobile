import "dart:async";

import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_outlined_button.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/source/teacher_exam_remote_data_source.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/widgets/ai_generation_status_card.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/widgets/ai_refine_question_sheet.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/widgets/edit_question_sheet.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/widgets/exam_config_summary_card.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/widgets/exam_generation_steps.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/widgets/exam_question_card.dart";
import "package:flutter/material.dart";

class ExamGenerationStep3 extends StatefulWidget {
  final String? generationId;
  final String? examId;
  final String topic;
  final String classroomId;
  final String? classroomName;
  final String? subjectName;
  final String sectionId;
  final String? sectionTitle;
  final String difficultyLevel;
  final List<QuestionRequirementModel> questionRequirements;
  final int? durationMinutes;
  final int? allowedAttempts;
  final String? startDate;
  final String? endDate;

  const ExamGenerationStep3({
    super.key,
    this.generationId,
    this.examId,
    required this.topic,
    required this.classroomId,
    this.classroomName,
    this.subjectName,
    required this.sectionId,
    this.sectionTitle,
    this.difficultyLevel = "easy",
    this.questionRequirements = const [],
    this.durationMinutes,
    this.allowedAttempts,
    this.startDate,
    this.endDate,
  });

  @override
  State<ExamGenerationStep3> createState() => _ExamGenerationStep3State();
}

class _ExamGenerationStep3State extends State<ExamGenerationStep3> {
  Timer? _pollingTimer;
  int _pollCount = 0;

  bool _isLoading = false;
  String? _resolvedExamId;
  ExamGenerationStatusModel? _generationStatus;
  //TeacherExamDetailModel? _examDetails;
  List<TeacherExamQuestionModel> _questions = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _resolvedExamId = widget.examId;

    if (widget.generationId != null && widget.generationId!.isNotEmpty) {
      _startPolling(widget.generationId!);
    } else if (_resolvedExamId != null && _resolvedExamId!.isNotEmpty) {
      _loadExamDetails(_resolvedExamId!);
    } else {
      _setupSampleQuestions();
    }
  }

  void _setupSampleQuestions() {
    _questions = [
      const TeacherExamQuestionModel(
        id: "sample-1",
        text:
            "ما هو المفهوم الأساسي للـ Containerization في تقنيات الحوسبة السحابية؟",
        type: "MultipleChoice",
        difficulty: "easy",
        options: [
          TeacherExamQuestionOptionModel(
            text:
                "عزل التطبيق واعتمادياته داخل بيئة تشغيلية خفيفة الوزن ومستقلة",
            isCorrect: true,
          ),
          TeacherExamQuestionOptionModel(
            text: "محاكاة نظام تشغيل كامل مع عتاد افتراضي مخصص",
            isCorrect: false,
          ),
          TeacherExamQuestionOptionModel(
            text: "ضغط ملفات المشروع بصيغة مضغوطة",
            isCorrect: false,
          ),
          TeacherExamQuestionOptionModel(
            text: "تشفير قواعد البيانات فقط",
            isCorrect: false,
          ),
        ],
      ),
      const TeacherExamQuestionModel(
        id: "sample-2",
        text:
            "تعتبر وحدات التخزين (Volumes) في Docker مستقلة تماماً عن دورة حياة الحاوية وتضمن استمرارية البيانات.",
        type: "TrueFalse",
        difficulty: "medium",
        options: [
          TeacherExamQuestionOptionModel(text: "صح", isCorrect: true),
          TeacherExamQuestionOptionModel(text: "خطأ", isCorrect: false),
        ],
      ),
      const TeacherExamQuestionModel(
        id: "sample-3",
        text: "اشرح باختصار الفرق بين الـ Image والـ Container في بيئة Docker.",
        type: "ShortAnswer",
        difficulty: "medium",
        rubric:
            "يجب ذكر أن Image هي قالب للقراءة فقط (Blueprint)، بينما الـ Container هو نسخة تشغيلية حية من تلك الـ Image.",
      ),
    ];
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling(String generationId) {
    _pollingTimer?.cancel();
    _pollCount = 0;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _generationStatus = ExamGenerationStatusModel(
        id: generationId,
        status: 0,
        statusName: "Pending",
        requestedCount: widget.questionRequirements.fold(
          0,
          (sum, r) => sum + r.count,
        ),
        generatedCount: 0,
      );
    });

    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      _pollCount++;
      if (_pollCount > 60) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage =
                "استغرقت عملية التوليد وقتاً أطول من المتوقع، يرجى المحاولة مرة أخرى.";
          });
        }
        return;
      }

      try {
        final remote = getIt<TeacherExamRemoteDataSource>();
        final status = await remote.getGenerationStatus(generationId);

        if (!mounted) return;

        setState(() {
          _generationStatus = status;
        });

        if (status.isCompleted || status.isCompletedWithWarning) {
          timer.cancel();
          final examId = status.examId;
          if (examId != null && examId.isNotEmpty) {
            _resolvedExamId = examId;
            await _loadExamDetails(examId);
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        } else if (status.isFailed || status.isDataUnavailable) {
          timer.cancel();
          setState(() {
            _isLoading = false;
            _errorMessage = status.localizedStatusArabic;
          });
        }
      } catch (e) {
        // Continue polling until timeout or retry
      }
    });
  }

  Future<void> _loadExamDetails(String examId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final remote = getIt<TeacherExamRemoteDataSource>();
      final details = await remote.getExamDetails(examId);

      if (mounted) {
        setState(() {
          //_examDetails = details;
          _questions = List.from(details.questions);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "تعذر تحميل تفاصيل الأسئلة: ${e.toString()}";
        });
      }
    }
  }

  Future<void> _deleteQuestion(int index) async {
    final question = _questions[index];
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text("حذف السؤال"),
          ],
        ),
        content: Text(
          "هل أنت متأكد من رغبتك في حذف السؤال رقم (${index + 1})؟",
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("حذف"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (_resolvedExamId != null && _resolvedExamId!.isNotEmpty) {
      try {
        final remote = getIt<TeacherExamRemoteDataSource>();
        await remote.deleteQuestion(
          examId: _resolvedExamId!,
          questionId: question.id,
        );
      } catch (e) {
        _showSnackBar("فشل حذف السؤال من السيرفر: ${e.toString()}");
      }
    }

    setState(() {
      _questions.removeAt(index);
    });
    _showSnackBar("تم حذف السؤال بنجاح");
  }

  void _openManualAddQuestionDialog() {
    EditQuestionSheet.show(
      context: context,
      initialQuestion: null,
      onSave: (newQuestion) async {
        if (_resolvedExamId != null && _resolvedExamId!.isNotEmpty) {
          try {
            final remote = getIt<TeacherExamRemoteDataSource>();
            final newId = await remote.addQuestion(
              examId: _resolvedExamId!,
              question: newQuestion,
            );
            final created = newQuestion.copyWith(id: newId);
            setState(() {
              _questions.add(created);
            });
            _showSnackBar("تم إضافة السؤال الجديد بنجاح");
            return;
          } catch (e) {
            _showSnackBar("فشل إضافة السؤال للسيرفر: ${e.toString()}");
          }
        }

        setState(() {
          _questions.add(
            newQuestion.copyWith(
              id: "local-${DateTime.now().millisecondsSinceEpoch}",
            ),
          );
        });
        _showSnackBar("تم إضافة السؤال");
      },
    );
  }

  void _openManualEditQuestionDialog(int index) {
    final currentQuestion = _questions[index];
    EditQuestionSheet.show(
      context: context,
      initialQuestion: currentQuestion,
      onSave: (updatedQuestion) async {
        if (_resolvedExamId != null && _resolvedExamId!.isNotEmpty) {
          try {
            final remote = getIt<TeacherExamRemoteDataSource>();
            await remote.updateQuestion(
              examId: _resolvedExamId!,
              questionId: currentQuestion.id,
              question: updatedQuestion,
            );
          } catch (e) {
            _showSnackBar("فشل حفظ التعديل على السيرفر: ${e.toString()}");
          }
        }

        setState(() {
          _questions[index] = updatedQuestion.copyWith(id: currentQuestion.id);
        });
        _showSnackBar("تم تحديث السؤال بنجاح");
      },
    );
  }

  void _openAiRefineDialog(int index) {
    final currentQuestion = _questions[index];
    AiRefineQuestionSheet.show(
      context: context,
      examId: _resolvedExamId ?? "",
      question: currentQuestion,
      onApply: (refinedQuestion) async {
        if (_resolvedExamId != null && _resolvedExamId!.isNotEmpty) {
          try {
            final remote = getIt<TeacherExamRemoteDataSource>();
            await remote.updateQuestion(
              examId: _resolvedExamId!,
              questionId: currentQuestion.id,
              question: refinedQuestion,
            );
          } catch (e) {
            // Server warning
          }
        }

        setState(() {
          _questions[index] = refinedQuestion;
        });
        _showSnackBar("تم تطبيق الصياغة الجديدة بنجاح");
      },
    );
  }

  void _finalizeExam() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(AppSizes.s24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.chemistryBiology.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.chemistryBiology,
                size: 48,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "تم اعتماد ونشر الامتحان بنجاح!",
              textAlign: TextAlign.center,
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "أصبح الامتحان متاحاً الآن لطلاب الفصل الدراسي (${widget.classroomName ?? widget.topic}) وفق الجدول الزمني المحدد.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  AppNavigator.goAndRemove(
                    context: context,
                    path: AppRoutes.teacherDashboardPage,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "العودة للوحة التحكم",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPolling =
        _isLoading &&
        _generationStatus != null &&
        !_generationStatus!.isFinished;

    return Scaffold(
      appBar: const CustomAppBar(title: "مراجعة واعتماد الأسئلة"),
      drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ExamGenerationSteps(currentStep: 3),
              const SizedBox(height: AppSizes.s16),

              // If currently polling status
              if (isPolling)
                FadeInUp(
                  delay: 40,
                  child: AiGenerationStatusCard(status: _generationStatus!),
                )
              else if (_errorMessage != null && _questions.isEmpty)
                FadeInUp(
                  delay: 40,
                  child: _buildErrorCard(),
                )
              else ...[
                // Exam Summary Info Banner
                FadeInUp(
                  delay: 40,
                  child: ExamConfigSummaryCard(
                    topic: widget.topic,
                    classroomName: widget.classroomName,
                    subjectName: widget.subjectName,
                    sectionTitle: widget.sectionTitle,
                    difficultyLevel: widget.difficultyLevel,
                    questionRequirements: widget.questionRequirements,
                    durationMinutes: widget.durationMinutes,
                    allowedAttempts: widget.allowedAttempts,
                  ),
                ),
                const SizedBox(height: AppSizes.s20),

                // Questions Header & Add Button
                FadeInUp(
                  delay: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "الأسئلة (${_questions.length})",
                            style: AppTextStyles.h4.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "راجع وصحح أو أضف أسئلة جديدة قبل النشر",
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _openManualAddQuestionDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary50,
                          foregroundColor: AppColors.primary700,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(color: AppColors.primary200),
                          ),
                        ),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text(
                          "إضافة سؤال",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.s14),

                // Questions List
                if (_questions.isEmpty)
                  _buildEmptyQuestionsState()
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _questions.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSizes.s14),
                    itemBuilder: (context, index) {
                      final question = _questions[index];
                      return FadeInUp(
                        delay: (index % 6) * 50,
                        child: ExamQuestionCard(
                          question: question,
                          index: index,
                          onAiRefine: () => _openAiRefineDialog(index),
                          onManualEdit: () =>
                              _openManualEditQuestionDialog(index),
                          onDelete: () => _deleteQuestion(index),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: AppSizes.s24),

                // Final Publish Exam Action
                FadeInUp(
                  delay: 140,
                  child: AppElevatedButton(
                    onPressed: _questions.isEmpty ? null : _finalizeExam,
                    label: "اعتماد ونشر الامتحان للطلاب",
                  ),
                ),
                const SizedBox(height: AppSizes.s12),

                // Back Button
                FadeInUp(
                  delay: 180,
                  child: AppOutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    label: "الرجوع لتعديل إعدادات الوقت والجدولة",
                  ),
                ),
                const SizedBox(height: AppSizes.s32),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(
            "تعذر إتمام عملية التوليد",
            style: AppTextStyles.h5.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "حدث خطأ غير متوقع أثناء معالجة الأسئلة.",
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(fontSize: 12.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_resolvedExamId != null &&
                        _resolvedExamId!.isNotEmpty) {
                      _loadExamDetails(_resolvedExamId!);
                    } else if (widget.generationId != null &&
                        widget.generationId!.isNotEmpty) {
                      _startPolling(widget.generationId!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text("إعادة المحاولة"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("الرجوع للإعدادات"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyQuestionsState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.quiz_outlined,
            size: 48,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 12),
          Text(
            "لا توجد أسئلة مضافة حالياً",
            style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            "يمكنك إضافة أسئلة يدوياً أو العودة لتوليد أسئلة بالذكاء الاصطناعي.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

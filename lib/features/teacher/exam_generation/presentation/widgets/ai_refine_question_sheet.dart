import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_outlined_button.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/source/teacher_exam_remote_data_source.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class AiRefineQuestionSheet extends StatefulWidget {
  final String examId;
  final TeacherExamQuestionModel question;
  final ValueChanged<TeacherExamQuestionModel> onApply;

  const AiRefineQuestionSheet({
    super.key,
    required this.examId,
    required this.question,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required String examId,
    required TeacherExamQuestionModel question,
    required ValueChanged<TeacherExamQuestionModel> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AiRefineQuestionSheet(
        examId: examId,
        question: question,
        onApply: onApply,
      ),
    );
  }

  @override
  State<AiRefineQuestionSheet> createState() => _AiRefineQuestionSheetState();
}

class _AiRefineQuestionSheetState extends State<AiRefineQuestionSheet> {
  final _instructionController = TextEditingController();
  bool _isRefining = false;
  RefinedQuestionResponseModel? _refinedResult;
  String? _errorMessage;

  @override
  void dispose() {
    _instructionController.dispose();
    super.dispose();
  }

  Future<void> _refine() async {
    final instruction = _instructionController.text.trim();
    if (instruction.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("يرجى كتابة تعليمات التحسين أولاً"),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _isRefining = true;
      _errorMessage = null;
    });

    try {
      final remote = getIt<TeacherExamRemoteDataSource>();
      final result = await remote.refineQuestion(
        examId: widget.examId.isNotEmpty ? widget.examId : "mock",
        questionId: widget.question.id,
        instruction: instruction,
      );

      if (mounted) {
        setState(() {
          _refinedResult = result;
          _isRefining = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRefining = false;
          _errorMessage = "فشل تحسين السؤال: ${e.toString()}";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.s20,
        right: AppSizes.s20,
        top: AppSizes.s20,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.s24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.ai100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.wandMagicSparkles,
                    color: AppColors.ai700,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "تحسين السؤال بالذكاء الاصطناعي",
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    fontSize: 15.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 16),

            // Current Question Preview
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundMuted,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "نص السؤال الأصلي:",
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.question.text,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Instruction Input
            Text(
              "ما التعديل أو التحسين المطلوب؟",
              style: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            AppTextFormField(
              controller: _instructionController,
              hintText: "مثال: اجعل السؤال بصيغة سيناريو عملي وزد درجة الصعوبة",
            ),
            const SizedBox(height: 10),

            // Quick Prompt Chips
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildQuickPromptChip("اجعله سيناريو تطبيقي 💡"),
                _buildQuickPromptChip("زيادة درجة الصعوبة 🎯"),
                _buildQuickPromptChip("تبسيط الصياغة والخيارات ✨"),
                _buildQuickPromptChip("إضافة أمثلة عملية 💻"),
              ],
            ),
            const SizedBox(height: 16),

            // Error message if any
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.error, fontSize: 12),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Refine Result Preview
            if (_refinedResult != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.ai50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.ai300, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.ai700,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "النتيجة بعد التحسين:",
                          style: AppTextStyles.label.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ai900,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _refinedResult!.text,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontSize: 13.5,
                      ),
                    ),
                    if (_refinedResult!.options.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      ..._refinedResult!.options.map((opt) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Icon(
                                opt.isCorrect
                                    ? Icons.check_box_rounded
                                    : Icons.check_box_outline_blank_rounded,
                                size: 16,
                                color: opt.isCorrect
                                    ? AppColors.chemistryBiology
                                    : AppColors.textDisabled,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  opt.text,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: opt.isCorrect
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: opt.isCorrect
                                        ? AppColors.chemistryBiology
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action Buttons
            if (_refinedResult == null)
              AppElevatedButton(
                onPressed: _isRefining ? () {} : _refine,
                label: _isRefining
                    ? "جاري إعادة الصياغة..."
                    : "إعادة الصياغة الآن",
              )
            else
              Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      onPressed: () {
                        setState(() {
                          _refinedResult = null;
                        });
                      },
                      label: "إعادة المحاولة",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppElevatedButton(
                      onPressed: () {
                        final updated = widget.question.copyWith(
                          text: _refinedResult!.text,
                          type: _refinedResult!.type,
                          difficulty: _refinedResult!.difficulty,
                          rubric: _refinedResult!.rubric,
                          options: _refinedResult!.options,
                        );
                        widget.onApply(updated);
                        Navigator.pop(context);
                      },
                      label: "اعتماد وتطبيق",
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPromptChip(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _instructionController.text = label
              .replaceAll(RegExp(r"[^\w\s\u0600-\u06FF]"), "")
              .trim();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.ai50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.ai300),
        ),
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.ai700,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class ExamResultsScreen extends StatelessWidget {
  final StudentExam? exam;
  final ExamAttemptResult result;
  final VoidCallback onFinish;

  const ExamResultsScreen({
    super.key,
    this.exam,
    required this.result,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = result.scorePercentage;
    final isPassed = percentage >= 50;
    final dateStr = result.submittedAt != null
        ? DateFormat("d MMM yyyy, h:mm a", "ar").format(result.submittedAt!)
        : "اليوم";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "نتيجة الامتحان",
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.s20),
          children: [
            // Score Summary Card
            _buildScoreSummaryCard(percentage, isPassed, dateStr),
            const SizedBox(height: AppSizes.s16),

            // Warning banner if teacher review needed
            if (result.needsTeacherReview) ...[
              _buildTeacherReviewBanner(),
              const SizedBox(height: AppSizes.s16),
            ],

            // Questions review header
            Row(
              children: [
                const Icon(
                  Icons.rate_review_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "تفاصيل إجابات الأسئلة (${result.answers.length} سؤال):",
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s12),

            // List of graded questions
            ...result.answers.asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;
              final question = exam?.questions.firstWhere(
                (q) => q.id == answer.examQuestionId,
                orElse: () => ExamQuestion(
                  id: answer.examQuestionId,
                  text: "السؤال ${index + 1}",
                  type: QuestionType.multipleChoice,
                  difficulty: "easy",
                ),
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.s12),
                child: _buildAnswerResultCard(
                  index: index,
                  question: question!,
                  answer: answer,
                ),
              );
            }),

            const SizedBox(height: AppSizes.s20),

            // Return button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onFinish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                label: Text(
                  "إنهاء والعودة",
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSummaryCard(
    double percentage,
    bool isPassed,
    String dateStr,
  ) {
    final scoreColor = isPassed ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: scoreColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: scoreColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    "${percentage.toStringAsFixed(0)}%",
                    style: AppTextStyles.h3.copyWith(
                      color: scoreColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam?.title ?? "الامتحان",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.h5.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "الدرجة الكلية: ${result.finalScore.toStringAsFixed(1)} من ${result.maxPossibleScore.toStringAsFixed(1)}",
                      style: AppTextStyles.body.copyWith(
                        color: scoreColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "وقت التسليم: $dateStr",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherReviewBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.amber,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "قيد مراجعة المعلم",
                  style: AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.amber,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "بعض الإجابات المقالية تتطلب مراجعة وتأكيد من قبل معلمك. قد تتغير الدرجة النهائية بعد المراجعة.",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerResultCard({
    required int index,
    required ExamQuestion question,
    required GradedAnswer answer,
  }) {
    final grading = answer.gradingResult;
    final score = grading?.score ?? 0.0;
    final maxScore = grading?.maxScore ?? 1.0;
    final isFullScore = score >= maxScore && maxScore > 0;
    final isPartial = score > 0 && score < maxScore;

    Color statusColor;
    if (isFullScore) {
      statusColor = AppColors.success;
    } else if (isPartial) {
      statusColor = AppColors.amber;
    } else {
      statusColor = AppColors.error;
    }

    // Selected option text if MCQ
    String? selectedOptionText;
    if (answer.selectedOptionId != null) {
      final match = question.options
          .where((o) => o.id == answer.selectedOptionId)
          .firstOrNull;
      selectedOptionText = match?.text;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Question index + score pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "السؤال ${index + 1} (${question.type.toDisplayString()})",
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${score.toStringAsFixed(1)} / ${maxScore.toStringAsFixed(1)}",
                  style: AppTextStyles.label.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Question Text
          Text(
            question.text,
            textAlign: TextAlign.right,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 10),

          // Student Answer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "إجابتك:",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  selectedOptionText ??
                      (answer.answerText != null &&
                              answer.answerText!.trim().isNotEmpty
                          ? answer.answerText!
                          : "لم تتم الإجابة"),
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),

          // AI Rationale if essay / ai-graded
          // if (grading?.rationale != null &&
          //     grading!.rationale!.trim().isNotEmpty) ...[
          //   const SizedBox(height: 8),
          //   Container(
          //     width: double.infinity,
          //     padding: const EdgeInsets.all(10),
          //     decoration: BoxDecoration(
          //       color: AppColors.ai50,
          //       borderRadius: BorderRadius.circular(10),
          //       border: Border.all(
          //         color: AppColors.ai300.withValues(alpha: 0.5),
          //       ),
          //     ),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const Icon(
          //           Icons.auto_awesome_rounded,
          //           size: 16,
          //           color: AppColors.ai700,
          //         ),
          //         const SizedBox(width: 8),
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 "تقييم وملاحظات الذكاء الاصطناعي:",
          //                 style: AppTextStyles.label.copyWith(
          //                   color: AppColors.ai700,
          //                   fontWeight: FontWeight.w700,
          //                   fontSize: 11,
          //                 ),
          //               ),
          //               const SizedBox(height: 2),
          //               Text(
          //                 grading.rationale!,
          //                 style: AppTextStyles.body.copyWith(
          //                   color: AppColors.textPrimary,
          //                   fontSize: 12,
          //                   height: 1.4,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          ],
      ),
    );
  }
}

import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/students_grades/data/models/attempt_review_models.dart";
import "package:flutter/material.dart";

class AnswerReviewCard extends StatelessWidget {
  final AttemptAnswerModel answer;
  final int index;
  final double? overrideValue;
  final bool isSubmitting;
  final void Function(double) onOverrideChanged;
  final VoidCallback onSaveOverride;

  const AnswerReviewCard({
    super.key,
    required this.answer,
    required this.index,
    this.overrideValue,
    this.isSubmitting = false,
    required this.onOverrideChanged,
    required this.onSaveOverride,
  });

  static const Map<String, String> _typeLabels = {
    "multiplechoice": "اختيار من متعدد",
    "mcq": "اختيار من متعدد",
    "essay": "سؤال مقالي",
    "truefalse": "صح أم خطأ",
    "fillintheblank": "أكمل الفراغ",
    "shortanswer": "إجابة قصيرة",
  };

  bool get _needsReview =>
      answer.gradingResult?.needsTeacherReview == true &&
      answer.gradingResult?.isFinalized == false;

  bool get _hasTeacherOverride =>
      answer.gradingResult?.teacherOverrideScore != null ||
      (answer.gradingResult?.reviewedByTeacherId?.isNotEmpty ?? false);

  Color get _scoreColor {
    final grading = answer.gradingResult;
    if (grading == null) return AppColors.textSecondary;
    final ratio = grading.maxScore > 0
        ? grading.score / grading.maxScore
        : 0.0;
    if (_hasTeacherOverride) return AppColors.primary700;
    if (ratio >= 0.85) return AppColors.success;
    if (ratio >= 0.5) return AppColors.amber;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final grading = answer.gradingResult;

    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.s16),
        border: Border.all(
          color: _needsReview
              ? AppColors.amber.withValues(alpha: 0.5)
              : AppColors.border,
          width: _needsReview ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "السؤال ${index + 1}"
                  "${answer.questionType != null ? " (${_typeLabels[answer.questionType!.toLowerCase()] ?? answer.questionType})" : ""}",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _scoreColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.s8),
                ),
                child: Text(
                  "${(grading?.score ?? 0).toStringAsFixed(1)} / ${(grading?.maxScore ?? 1).toStringAsFixed(1)}",
                  style: AppTextStyles.label.copyWith(
                    color: _scoreColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s8),
          if (_needsReview) _buildReviewBadge(),
          Text(
            answer.questionText ?? "سؤال ${index + 1}",
            textAlign: TextAlign.right,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 13.5,
            ),
          ),
          if ((answer.rubric ?? "").trim().isNotEmpty) ...[
            const SizedBox(height: AppSizes.s8),
            _buildInfoBox(
              icon: Icons.rule_rounded,
              label: "معايير التصحيح:",
              value: answer.rubric!,
              background: AppColors.backgroundAccent,
              border: AppColors.border,
            ),
          ],
          const SizedBox(height: AppSizes.s10),
          _buildInfoBox(
            icon: Icons.edit_note_rounded,
            label: "إجابة الطالب:",
            value:
                (answer.answerText != null && answer.answerText!.trim().isNotEmpty)
                    ? answer.answerText!
                    : "لم تتم الإجابة",
            background: AppColors.backgroundSecondary,
            border: AppColors.border,
          ),
          if ((grading?.rationale ?? "").trim().isNotEmpty) ...[
            const SizedBox(height: AppSizes.s8),
            _buildInfoBox(
              icon: Icons.auto_awesome_rounded,
              label: "تقييم الذكاء الاصطناعي:",
              value: grading!.rationale!,
              background: AppColors.ai50,
              border: AppColors.ai300.withValues(alpha: 0.5),
              iconColor: AppColors.ai700,
              textStyle: AppColors.ai700,
            ),
          ],
          if (_hasTeacherOverride && !_needsReview) ...[
            const SizedBox(height: AppSizes.s8),
            Row(
              children: [
                const Icon(
                  Icons.verified_rounded,
                  size: AppSizes.s14,
                  color: AppColors.primary700,
                ),
                const SizedBox(width: AppSizes.s4),
                Text(
                  "تمت مراجعة هذه الإجابة بواسطة المعلم"
                  "${grading?.teacherOverrideScore != null ? " — الدرجة: ${grading!.teacherOverrideScore!.toStringAsFixed(1)}" : ""}",
                  style: AppTextStyles.label.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary700,
                  ),
                ),
              ],
            ),
          ],
          if (_needsReview) _buildOverrideSection(),
        ],
      ),
    );
  }

  Widget _buildReviewBadge() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.s8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s8,
          vertical: AppSizes.s4,
        ),
        decoration: BoxDecoration(
          color: AppColors.amber.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(AppSizes.s6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.priority_high_rounded,
              size: AppSizes.s12,
              color: AppColors.amber,
            ),
            const SizedBox(width: AppSizes.s4),
            Text(
              "تحتاج مراجعة المعلم قبل اعتماد الدرجة",
              style: AppTextStyles.label.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppColors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String label,
    required String value,
    required Color background,
    required Color border,
    Color? iconColor,
    Color? textStyle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSizes.s10),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppSizes.s14, color: iconColor ?? AppColors.textSecondary),
              const SizedBox(width: AppSizes.s4),
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  color: textStyle ?? AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverrideSection() {
    final maxScore = answer.gradingResult?.maxScore ?? 1.0;

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.s12),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: overrideValue?.toStringAsFixed(1) ??
                  (answer.gradingResult?.score.toStringAsFixed(1) ?? "0"),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: "الدرجة الجديدة (من $maxScore)",
                hintStyle: AppTextStyles.label.copyWith(
                  fontSize: 11,
                  color: AppColors.textDisabled,
                ),
                prefixIcon: const Icon(
                  Icons.grade_rounded,
                  size: 18,
                  color: AppColors.primary700,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s12,
                  vertical: AppSizes.s10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.s10),
                  borderSide: const BorderSide(color: AppColors.borderStrong),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.s10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
              onChanged: (value) {
                final parsed = double.tryParse(value.trim());
                if (parsed != null) {
                  onOverrideChanged(parsed.clamp(0, maxScore));
                }
              },
            ),
          ),
          const SizedBox(width: AppSizes.s8),
          ElevatedButton.icon(
            onPressed: overrideValue == null || isSubmitting
                ? null
                : onSaveOverride,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary700,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.border,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s14,
                vertical: AppSizes.s10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.s10),
              ),
              elevation: 0,
            ),
            icon: isSubmitting
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_rounded, size: 18),
            label: Text(
              "اعتماد",
              style: AppTextStyles.button.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

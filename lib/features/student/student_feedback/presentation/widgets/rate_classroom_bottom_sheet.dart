import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/student_feedback/presentation/widgets/star_rating_input.dart";
import "package:flutter/material.dart";

class RateClassroomBottomSheet extends StatefulWidget {
  final String classroomName;
  final Future<bool> Function(int rating, String comment) onSubmit;

  const RateClassroomBottomSheet({
    super.key,
    required this.classroomName,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required String classroomName,
    required Future<bool> Function(int rating, String comment) onSubmit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RateClassroomBottomSheet(
        classroomName: classroomName,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<RateClassroomBottomSheet> createState() =>
      _RateClassroomBottomSheetState();
}

class _RateClassroomBottomSheetState extends State<RateClassroomBottomSheet> {
  int _rating = 0;
  bool _submitting = false;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0 || _commentController.text.trim().isEmpty) return;

    setState(() => _submitting = true);

    final success =
        await widget.onSubmit(_rating, _commentController.text.trim());

    if (!mounted) return;

    setState(() => _submitting = false);

    if (success) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary200),
                  ),
                  child: const Icon(
                    Icons.rate_review_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "قيّم هذا الفصل",
                        style: AppTextStyles.h5.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        widget.classroomName,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            StarRatingInput(
              rating: _rating,
              onRatingChanged: (value) => setState(() => _rating = value),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                _ratingLabel,
                key: ValueKey<int>(_rating),
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 4,
              minLines: 3,
              maxLength: 500,
              textAlignVertical: TextAlignVertical.top,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: "اكتب رأيك عن الفصل والمعلم...",
                hintStyle: AppTextStyles.body
                    .copyWith(color: AppColors.textDisabled),
                filled: true,
                fillColor: AppColors.backgroundSecondary,
                counterStyle: AppTextStyles.label
                    .copyWith(color: AppColors.textDisabled, fontSize: 11),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.primary300, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed:
                  (_rating > 0 && !_submitting) ? _submit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              icon: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(
                _submitting ? "جارِ الإرسال..." : "إرسال التقييم",
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _ratingLabel {
    switch (_rating) {
      case 1:
        return "سيء جداً";
      case 2:
        return "سيء";
      case 3:
        return "مقبول";
      case 4:
        return "جيد";
      case 5:
        return "ممتاز";
      default:
        return "اختر تقييمك";
    }
  }
}

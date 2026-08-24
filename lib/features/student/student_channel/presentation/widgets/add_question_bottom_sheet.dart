import "dart:io";

import "package:flutter/material.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/question_image_attachment.dart";

class AddQuestionBottomSheet extends StatefulWidget {
  final void Function(String content, File? image) onSubmit;
  final bool isLoading;

  const AddQuestionBottomSheet({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<AddQuestionBottomSheet> createState() => _AddQuestionBottomSheetState();
}

class _AddQuestionBottomSheetState extends State<AddQuestionBottomSheet> {
  late final TextEditingController _controller;
  bool _hasText = false;
  File? _attachedImage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSubmit => !widget.isLoading && _hasText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
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
                      "طرح سؤال جديد",
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "اطرح سؤالك بوضوح ليتمكن المعلم والزملاء من إجابتك",
                      style: AppTextStyles.label.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.foregroundMuted),
                onPressed: widget.isLoading ? null : () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Input area
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderStrong),
            ),
            child: TextField(
              controller: _controller,
              maxLines: 6,
              minLines: 3,
              enabled: !widget.isLoading,
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: "اكتب سؤالك بالتفصيل هنا...",
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textDisabled,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Image attachment section
          QuestionImageAttachment(
            enabled: !widget.isLoading,
            hint: "إرفاق صورة توضيحية (اختياري)",
            onImageChanged: (image) => setState(() => _attachedImage = image),
          ),
          const SizedBox(height: 20),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed:
                  _canSubmit ? () => widget.onSubmit(_controller.text.trim(), _attachedImage) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary100,
                disabledForegroundColor: AppColors.primary300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              icon: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: 20),
              label: Text(
                widget.isLoading
                    ? (_attachedImage != null ? "جاري رفع الصورة والنشر..." : "جاري النشر...")
                    : "نشر السؤال",
                style: AppTextStyles.button.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

import "../theme/app_colors.dart";
import "../theme/app_text_styles.dart";

/// A polished photo attachment section used in question/reply composers.
/// Handles gallery/camera picking, client-side compression and validation
/// (allowed extensions + max size), with a preview card and remove action.
class QuestionImageAttachment extends StatefulWidget {
  final ValueChanged<File?> onImageChanged;
  final bool enabled;
  final String hint;

  const QuestionImageAttachment({
    super.key,
    required this.onImageChanged,
    this.enabled = true,
    this.hint = "إرفاق صورة (اختياري)",
  });

  static const int maxImageSizeBytes = 5 * 1024 * 1024;
  static const List<String> allowedExtensions = [
    "jpg",
    "jpeg",
    "png",
    "webp",
    "gif",
  ];

  @override
  State<QuestionImageAttachment> createState() =>
      _QuestionImageAttachmentState();
}

class _QuestionImageAttachmentState extends State<QuestionImageAttachment> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (!mounted || pickedFile == null) return;

      final extension = pickedFile.name.split(".").last.toLowerCase();
      if (!QuestionImageAttachment.allowedExtensions.contains(extension)) {
        _showError("صيغة الصورة غير مدعومة. المسموح: JPG و PNG و WEBP و GIF");
        return;
      }
      final lengthInBytes = await pickedFile.length();
      if (lengthInBytes > QuestionImageAttachment.maxImageSizeBytes) {
        _showError("حجم الصورة كبير جداً. الحد الأقصى 5 ميجابايت");
        return;
      }

      final image = File(pickedFile.path);
      setState(() => _pickedImage = image);
      widget.onImageChanged(image);
    } catch (_) {
      if (mounted) {
        _showError("تعذر اختيار الصورة، حاول مجدداً");
      }
    }
  }

  void _removeImage() {
    setState(() => _pickedImage = null);
    widget.onImageChanged(null);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.body.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _showSourceSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.borderStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                "اختر مصدر الصورة",
                style: AppTextStyles.h5.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _SourceOptionCard(
                      icon: Icons.photo_library_rounded,
                      label: "من المعرض",
                      onTap: () {
                        Navigator.pop(sheetContext);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SourceOptionCard(
                      icon: Icons.photo_camera_rounded,
                      label: "التقاط صورة",
                      onTap: () {
                        Navigator.pop(sheetContext);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: AlignmentDirectional.topStart,
      child: _pickedImage == null
          ? Align(
              alignment: AlignmentDirectional.centerStart,
              child: Semantics(
                label: widget.hint,
                button: true,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.enabled ? _showSourceSheet : null,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderStrong),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.hint,
                            style: AppTextStyles.label.copyWith(
                              fontSize: 12.5,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : _buildPreview(),
    );
  }

  Widget _buildPreview() {
    final imageSize = _pickedImage!.lengthSync();
    final sizeLabel = imageSize > 1024 * 1024
        ? "${(imageSize / (1024 * 1024)).toStringAsFixed(1)} ميجابايت"
        : "${(imageSize / 1024).round()} كيلوبايت";

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Image.file(
                _pickedImage!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.border,
                  child: const Icon(
                    Icons.image_not_supported_rounded,
                    color: AppColors.foregroundMuted,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تم إرفاق الصورة",
                  style: AppTextStyles.label.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sizeLabel,
                  style: AppTextStyles.label.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Semantics(
            label: "إزالة الصورة المرفقة",
            button: true,
            child: IconButton(
              onPressed: widget.enabled ? _removeImage : null,
              icon: const Icon(Icons.delete_outline_rounded),
              color: AppColors.error,
              tooltip: "إزالة الصورة",
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceOptionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary200),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

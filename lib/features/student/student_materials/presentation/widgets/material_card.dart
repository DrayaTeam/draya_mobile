import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class MaterialCard extends StatelessWidget {
  final StudentMaterial material;
  final bool isOpening;
  final VoidCallback onOpen;
  final VoidCallback? onDownload;

  const MaterialCard({
    super.key,
    required this.material,
    required this.isOpening,
    required this.onOpen,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final status = material.currentVersion;
    final date = DateFormat("d MMM yyyy", "ar").format(material.createdAt);
    final color = _typeColor(material.materialType);
    final hasDownload =
        status.isReady &&
        (status.fileUrl != null && status.fileUrl!.isNotEmpty);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: color.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Icon(
                    _typeIcon(material.materialType),
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        material.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.h5.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _typeLabel(material.materialType),
                              style: AppTextStyles.label.copyWith(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            date,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: status.isReady && !isOpening ? onOpen : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.borderStrong,
                      disabledForegroundColor: AppColors.textDisabled,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: isOpening
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Icon(
                            material.isVideo
                                ? Icons.play_circle_outline_rounded
                                : Icons.visibility_outlined,
                            size: 18,
                          ),
                    label: Text(
                      material.isVideo ? "مشاهدة الفيديو" : "عرض الملف",
                      style: AppTextStyles.button.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                if (hasDownload && onDownload != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary200),
                    ),
                    child: IconButton(
                      onPressed: onDownload,
                      tooltip: "تحميل الملف",
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.download_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type.toLowerCase()) {
      case "video":
        return "فيديو";
      case "pdf":
        return "مستند PDF";
      case "docx":
        return "مستند Word";
      case "pptx":
        return "عرض تقديمي";
      case "image":
        return "صورة";
      default:
        return "ملف";
    }
  }

  IconData _typeIcon(String type) {
    switch (type.toLowerCase()) {
      case "video":
        return Icons.play_circle_fill_rounded;
      case "pdf":
        return Icons.picture_as_pdf_rounded;
      case "docx":
        return Icons.article_rounded;
      case "pptx":
        return Icons.slideshow_rounded;
      case "image":
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case "video":
        return AppColors.ai700;
      case "pdf":
        return AppColors.error;
      case "docx":
        return AppColors.mathPhysics;
      case "pptx":
        return AppColors.amber;
      case "image":
        return AppColors.chemistryBiology;
      default:
        return AppColors.primary700;
    }
  }
}

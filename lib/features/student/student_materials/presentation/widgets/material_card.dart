import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaterialCard extends StatelessWidget {
  final StudentMaterial material;
  final bool isOpening;
  final VoidCallback onOpen;

  const MaterialCard({
    super.key,
    required this.material,
    required this.isOpening,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final status = material.currentVersion;
    final date = DateFormat('d MMM yyyy', 'ar').format(material.createdAt);
    final color = _typeColor(material.materialType);

    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.s16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.04),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: AppSizes.s48,
                height: AppSizes.s48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                ),
                child: Icon(_typeIcon(material.materialType), color: color),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.title,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      'أضيف في $date',
                      style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                ),
                child: IconButton(
                  onPressed: status.isReady && !isOpening ? onOpen : null,
                  icon: isOpening
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(
                          material.isVideo
                              ? Icons.play_circle_outline
                              : Icons.open_in_new_rounded,
                          color: AppColors.surface,    
                        ),
                 
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Icons.play_circle_fill_rounded;
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'docx':
        return Icons.article_rounded;
      case 'pptx':
        return Icons.slideshow_rounded;
      case 'image':
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return AppColors.ai700;
      case 'pdf':
        return AppColors.error;
      case 'docx':
        return AppColors.mathPhysics;
      case 'pptx':
        return AppColors.amber;
      case 'image':
        return AppColors.chemistryBiology;
      default:
        return AppColors.primary700;
    }
  }
}

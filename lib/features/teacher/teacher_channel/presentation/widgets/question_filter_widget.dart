import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class QuestionFilterWidget extends StatelessWidget {
  final String currentSort;
  final String currentFilter;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<String> onFilterChanged;

  const QuestionFilterWidget({
    super.key,
    required this.currentSort,
    required this.currentFilter,
    required this.onSortChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Semantics(
              label: 'ترتيب الأسئلة',
              button: true,
              child: _SortButton(
                label: _getSortLabel(currentSort),
                onTap: () => _showSortBottomSheet(context),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 1,
              height: 24,
              color: AppColors.borderStrong,
              margin: const EdgeInsets.symmetric(horizontal: 2),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'الكل',
              icon: Icons.all_inclusive_rounded,
              isSelected: currentFilter == 'all',
              onTap: () => onFilterChanged('all'),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'بدون إجابة',
              icon: Icons.help_outline_rounded,
              isSelected: currentFilter == 'unanswered',
              onTap: () => onFilterChanged('unanswered'),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'تمت الإجابة',
              icon: Icons.check_circle_outline_rounded,
              isSelected: currentFilter == 'answered',
              onTap: () => onFilterChanged('answered'),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'أسئلتي',
              icon: Icons.person_outline_rounded,
              isSelected: currentFilter == 'myposts',
              onTap: () => onFilterChanged('myposts'),
            ),
          ],
        ),
      ),
    );
  }

  String _getSortLabel(String sort) {
    switch (sort) {
      case 'recent':
        return 'الأحدث';
      case 'mostvoted':
        return 'الأكثر تصويتاً';
      case 'mostdiscussed':
        return 'الأكثر تفاعلاً';
      case 'trending':
        return 'الشائع';
      default:
        return 'ترتيب';
    }
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => Container(
        padding: const EdgeInsets.only(top: 8, bottom: 24, left: 16, right: 16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.sort_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'ترتيب حسب',
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 8),
            ...[
              ('recent', 'الأحدث', Icons.access_time_rounded),
              ('mostvoted', 'الأكثر تصويتاً', Icons.thumb_up_alt_outlined),
              (
                'mostdiscussed',
                'الأكثر تفاعلاً',
                Icons.chat_bubble_outline_rounded,
              ),
              ('trending', 'الشائع', Icons.local_fire_department_outlined),
            ].map((item) {
              final isSelected = currentSort == item.$1;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    onSortChanged(item.$1);
                    Navigator.pop(bottomSheetContext);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary50
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary200
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.$3,
                          size: 20,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.foregroundMuted,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.$2,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SortButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.swap_vert_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderStrong,
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.foregroundMuted,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  color: isSelected ? Colors.white : AppColors.foregroundMuted,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

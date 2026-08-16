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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Semantics(
            label: 'ترتيب الأسئلة',
            button: true,
            child: _FilterChip(
              label: _getSortLabel(currentSort),
              isSelected: false,
              onTap: () => _showSortBottomSheet(context),
              icon: Icons.sort,
            ),
          ),
          const SizedBox(width: 8),

          _FilterChip(
            label: 'الكل',
            isSelected: currentFilter == 'all',
            onTap: () => onFilterChanged('all'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'بدون إجابة',
            isSelected: currentFilter == 'unanswered',
            onTap: () => onFilterChanged('unanswered'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'مجاب عليه',
            isSelected: currentFilter == 'answered',
            onTap: () => onFilterChanged('answered'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'أسئلتي',
            isSelected: currentFilter == 'myposts',
            onTap: () => onFilterChanged('myposts'),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(String sort) {
    switch (sort) {
      case 'recent':
        return 'الأحدث';
      case 'mostvoted':
        return 'الأكثر تصويتًا';
      case 'mostdiscussed':
        return 'الأكثر تفاعلًا';
      case 'trending':
        return 'الشائع';
      default:
        return 'ترتيب';
    }
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ترتيب الأسئلة',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...[
              ('recent', 'الأحدث'),
              ('mostvoted', 'الأكثر تصويتًا'),
              ('mostdiscussed', 'الأكثر تفاعلًا'),
              ('trending', 'الشائع'),
            ].map((item) {
              return ListTile(
                title: Text(item.$2),
                selected: currentSort == item.$1,
                onTap: () {
                  onSortChanged(item.$1);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : theme.colorScheme.primary,
            ),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.transparent,
      side: BorderSide(
        color: theme.colorScheme.primary,
      ),
      selectedColor: theme.colorScheme.primary,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : theme.colorScheme.primary,
      ),
    );
  }
}

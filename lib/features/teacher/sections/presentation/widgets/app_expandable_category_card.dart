import "package:draya_mobile/core/helpers/app_extensions.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:flutter/material.dart";

class AppExpandableCategoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String label;
  final List<Widget> children;

  const AppExpandableCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.label,
    required this.children,
  });

  @override
  State<AppExpandableCategoryCard> createState() =>
      _AppExpandableCategoryCardState();
}

class _AppExpandableCategoryCardState extends State<AppExpandableCategoryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppSizes.s16),
        border: Border.all(
          color: AppColors.primary200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppSizes.s16),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s8,
                      vertical: AppSizes.s4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary200,
                      borderRadius: BorderRadius.circular(AppSizes.s8),
                    ),
                    child: Text(widget.label),
                  ),
                  const SizedBox(width: AppSizes.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSizes.s4),
                        Text(
                          widget.subtitle,
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),

          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSizes.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.children,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

class AppExpandableQuestionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String label;
  final List<Widget> children;
  final VoidCallback onDelete;

  const AppExpandableQuestionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.label,
    required this.children,
    required this.onDelete,
  });

  @override
  State<AppExpandableQuestionCard> createState() =>
      _AppExpandableQuestionCardState();
}

class _AppExpandableQuestionCardState extends State<AppExpandableQuestionCard> {
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
              padding: const EdgeInsets.all(AppSizes.s8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        Text(widget.title),
                        Text(widget.subtitle),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: widget.onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s12,
                vertical: AppSizes.s4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

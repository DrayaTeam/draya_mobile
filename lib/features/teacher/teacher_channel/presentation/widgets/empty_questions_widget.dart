import 'package:flutter/material.dart';

class EmptyQuestionsWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onRefresh;

  const EmptyQuestionsWidget({
    super.key,
    this.title = 'لا توجد أسئلة',
    this.subtitle = 'كن أول من يسأل!',
    this.icon = Icons.question_answer_outlined,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('تحديث'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

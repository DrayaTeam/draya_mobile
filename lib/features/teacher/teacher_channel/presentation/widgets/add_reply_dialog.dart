import 'package:flutter/material.dart';

class AddReplyDialog extends StatefulWidget {
  final String questionId;
  final ValueChanged<String> onSubmit;
  final bool isLoading;

  const AddReplyDialog({
    super.key,
    required this.questionId,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<AddReplyDialog> createState() => _AddReplyDialogState();
}

class _AddReplyDialogState extends State<AddReplyDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('أضف رد'),
      content: TextField(
        controller: _controller,
        maxLines: 5,
        minLines: 3,
        enabled: !widget.isLoading,
        decoration: InputDecoration(
          hintText: 'اكتب ردك هنا...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.isLoading ? null : () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: widget.isLoading
              ? null
              : () {
                final content = _controller.text;
                if (content.trim().isNotEmpty) {
                  widget.onSubmit(content);
                }
                },
          child: widget.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('نشر الرد'),
        ),
      ],
    );
  }
}

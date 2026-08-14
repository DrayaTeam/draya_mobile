import 'package:flutter/material.dart';

@immutable
class ExamItem {
  final String subject;
  final String title;
  final String teacher;
  final String statusLabel;
  final Color statusColor;
  final String duration;
  final String extraLabel;
  final Color extraColor;
  final String actionLabel;
  final bool actionEnabled;
  final Color actionColor;
  final Color subjectAccentColor;
  final Color subjectTextColor;

  const ExamItem({
    required this.subject,
    required this.title,
    required this.teacher,
    required this.statusLabel,
    required this.statusColor,
    required this.duration,
    required this.extraLabel,
    required this.extraColor,
    required this.actionLabel,
    required this.actionEnabled,
    required this.actionColor,
    required this.subjectAccentColor,
    required this.subjectTextColor,
  });

  const ExamItem.empty()
      : subject = 'الرياضيات',
        title = 'امتحان الجبر والتباديل والتوافيق',
        teacher = 'أ. أحمد السيد',
        statusLabel = 'متاح للحل الآن 🔥',
        statusColor = const Color(0xFFF59E0B),
        duration = '45 دقيقة',
        extraLabel = 'جاهز للبدء',
        extraColor = const Color(0xFFF59E0B),
        actionLabel = 'بدء الامتحان الآن',
        actionEnabled = true,
        actionColor = const Color(0xFF1B6D63),
        subjectAccentColor = const Color(0xFFDDF5F1),
        subjectTextColor = const Color(0xFF145A53);
}

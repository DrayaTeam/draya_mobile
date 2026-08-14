import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/student/exams/presentation/models/exam_item.dart';
import 'package:draya_mobile/features/student/exams/presentation/widgets/student_exam_details_body.dart';
import 'package:flutter/material.dart';

class StudentExamDetailsScreen extends StatelessWidget {
  final ExamItem exam;

  const StudentExamDetailsScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(drawerItemsList: getStudentDrawerItemsList()),
      appBar: const CustomAppBar(title: 'تفاصيل الامتحان'),
      body: StudentExamDetailsBody(exam: exam),
    );
  }
}

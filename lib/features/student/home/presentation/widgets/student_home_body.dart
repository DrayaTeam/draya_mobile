import 'package:flutter/material.dart';
import 'student_home_alerts_section.dart';
import 'student_home_course_and_exam_section.dart';
import 'student_home_learning_summary.dart';
import 'student_home_welcome_card.dart';

class StudentHomeBody extends StatelessWidget {
  const StudentHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 48),
      child: Column(
        children: [
          SizedBox(height: 16),
          StudentHomeWelcomeCard(),
          SizedBox(height: 24),
          StudentHomeLearningSummary(),
          SizedBox(height: 24),
          StudentHomeAlertsSection(),
          SizedBox(height: 24),
          StudentHomeCourseAndExamSection(),
          SizedBox(height: 24),
          // StudentHomeFocusSection(),
        ],
      ),
    );
  }
}

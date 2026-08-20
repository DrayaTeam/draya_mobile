import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/features/student/exams/presentation/cubit/student_exam_cubit.dart";
import "package:draya_mobile/features/student/exams/presentation/widgets/student_exam_details_body.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentExamDetailsScreen extends StatelessWidget {
  final String examId;
  final String? classroomName;

  const StudentExamDetailsScreen({
    super.key,
    required this.examId,
    this.classroomName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentExamCubit>(
      create: (_) => getIt<StudentExamCubit>(),
      child: StudentExamDetailsBody(
        examId: examId,
        classroomName: classroomName,
      ),
    );
  }
}

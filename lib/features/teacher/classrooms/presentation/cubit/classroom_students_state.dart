import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_error_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/student_roster_item_model.dart';

class ClassroomStudentsState {
  final CubitStatus status;
  final List<StudentRosterItemModel> students;
  final ApiErrorModel? apiErrorModel;

  const ClassroomStudentsState({
    this.status = CubitStatus.initial,
    this.students = const [],
    this.apiErrorModel,
  });

  ClassroomStudentsState copyWith({
    CubitStatus? status,
    List<StudentRosterItemModel>? students,
    ApiErrorModel? apiErrorModel,
  }) => ClassroomStudentsState(
    status: status ?? this.status,
    students: students ?? this.students,
    apiErrorModel: apiErrorModel,
  );
}

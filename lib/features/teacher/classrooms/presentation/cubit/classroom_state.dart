import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_error_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart';

class ClassroomState {
  final CubitStatus status;
  final List<ClassroomModel> classrooms;
  final ApiErrorModel? apiErrorModel;

  const ClassroomState({
    this.status = CubitStatus.initial,
    this.classrooms = const [],
    this.apiErrorModel,
  });

  ClassroomState copyWith({
    CubitStatus? status,
    List<ClassroomModel>? classrooms,
    ApiErrorModel? apiErrorModel,
  }) => ClassroomState(
    status: status ?? this.status,
    classrooms: classrooms ?? this.classrooms,
    apiErrorModel: apiErrorModel,
  );
}

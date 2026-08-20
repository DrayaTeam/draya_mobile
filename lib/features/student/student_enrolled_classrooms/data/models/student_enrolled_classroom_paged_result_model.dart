import "package:draya_mobile/features/student/student_enrolled_classrooms/data/models/student_enrolled_classroom_model.dart";
import "package:json_annotation/json_annotation.dart";

part "student_enrolled_classroom_paged_result_model.g.dart";

@JsonSerializable()
class StudentEnrolledClassroomPagedResultModel {
  final List<StudentEnrolledClassroomModel> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  const StudentEnrolledClassroomPagedResultModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory StudentEnrolledClassroomPagedResultModel.fromJson(
    Map<String, dynamic> json,
  ) => _$StudentEnrolledClassroomPagedResultModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$StudentEnrolledClassroomPagedResultModelToJson(this);
}

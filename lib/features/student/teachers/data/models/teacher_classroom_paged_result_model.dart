import 'package:draya_mobile/features/student/teachers/data/models/teacher_classroom_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'teacher_classroom_paged_result_model.g.dart';

@JsonSerializable()
class TeacherClassroomPagedResultModel {
  final List<TeacherClassroomModel> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  const TeacherClassroomPagedResultModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory TeacherClassroomPagedResultModel.fromJson(
    Map<String, dynamic> json,
  ) => _$TeacherClassroomPagedResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherClassroomPagedResultModelToJson(this);
}

import "package:draya_mobile/features/teacher/classrooms/data/models/student_roster_item_model.dart";
import "package:json_annotation/json_annotation.dart";

part "student_roster_paged_result_model.g.dart";

@JsonSerializable()
class StudentRosterPagedResultModel {
  final List<StudentRosterItemModel> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  const StudentRosterPagedResultModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory StudentRosterPagedResultModel.fromJson(Map<String, dynamic> json) =>
      _$StudentRosterPagedResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentRosterPagedResultModelToJson(this);
}

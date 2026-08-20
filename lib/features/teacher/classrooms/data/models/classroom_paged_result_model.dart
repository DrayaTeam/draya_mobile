import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:json_annotation/json_annotation.dart";

part "classroom_paged_result_model.g.dart";

@JsonSerializable()
class ClassroomPagedResultModel {
  final List<ClassroomModel> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  const ClassroomPagedResultModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory ClassroomPagedResultModel.fromJson(Map<String, dynamic> json) =>
      _$ClassroomPagedResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassroomPagedResultModelToJson(this);
}

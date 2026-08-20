import "package:draya_mobile/features/teacher/materials/data/models/teacher_material_model.dart";
import "package:json_annotation/json_annotation.dart";

part "teacher_material_paged_result_model.g.dart";

@JsonSerializable()
class TeacherMaterialPagedResultModel {
  final List<TeacherMaterialModel> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const TeacherMaterialPagedResultModel({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory TeacherMaterialPagedResultModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherMaterialPagedResultModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TeacherMaterialPagedResultModelToJson(this);
}

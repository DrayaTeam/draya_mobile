import "package:draya_mobile/features/student/student_materials/data/models/student_material_model.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart";
import "package:json_annotation/json_annotation.dart";

part "student_material_paged_result_model.g.dart";

@JsonSerializable()
class StudentMaterialPagedResultModel {
  final List<StudentMaterialModel> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const StudentMaterialPagedResultModel({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory StudentMaterialPagedResultModel.fromJson(Map<String, dynamic> json) =>
      _$StudentMaterialPagedResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentMaterialPagedResultModelToJson(this);
}

extension StudentMaterialPagedResultModelMapper on StudentMaterialPagedResultModel {
  StudentMaterialsPage toEntity() => StudentMaterialsPage(
    items: items.map((item) => item.toEntity()).toList(),
    pageNumber: pageNumber,
    pageSize: pageSize,
    totalCount: totalCount,
    totalPages: totalPages,
    hasPreviousPage: hasPreviousPage,
    hasNextPage: hasNextPage,
  );
}

import 'package:draya_mobile/features/student/student_materials/data/models/student_material_version_model.dart';
import 'package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_material_model.g.dart';

@JsonSerializable()
class StudentMaterialModel {
  final String materialId;
  final String title;
  final String materialType;
  final DateTime createdAt;
  final StudentMaterialVersionModel currentVersion;

  const StudentMaterialModel({
    required this.materialId,
    required this.title,
    required this.materialType,
    required this.createdAt,
    required this.currentVersion,
  });

  factory StudentMaterialModel.fromJson(Map<String, dynamic> json) =>
      _$StudentMaterialModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentMaterialModelToJson(this);
}

extension StudentMaterialModelMapper on StudentMaterialModel {
  StudentMaterial toEntity() => StudentMaterial(
    materialId: materialId,
    title: title,
    materialType: materialType,
    createdAt: createdAt,
    currentVersion: currentVersion.toEntity(),
  );
}

import "package:draya_mobile/features/teacher/materials/data/models/teacher_material_version_model.dart";
import "package:json_annotation/json_annotation.dart";

part "teacher_material_model.g.dart";

@JsonSerializable()
class TeacherMaterialModel {
  final String materialId;
  final String title;
  final String materialType;
  final DateTime createdAt;
  final TeacherMaterialVersionModel currentVersion;

  const TeacherMaterialModel({
    required this.materialId,
    required this.title,
    required this.materialType,
    required this.createdAt,
    required this.currentVersion,
  });

  factory TeacherMaterialModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherMaterialModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherMaterialModelToJson(this);
}

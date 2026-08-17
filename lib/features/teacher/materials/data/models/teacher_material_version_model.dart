import 'package:json_annotation/json_annotation.dart';

part 'teacher_material_version_model.g.dart';

@JsonSerializable()
class TeacherMaterialVersionModel {
  final String versionId;
  final int versionNumber;
  final String? fileUrl;
  final String parseStatus;
  final DateTime uploadedAt;
  final String? errorMessage;

  const TeacherMaterialVersionModel({
    required this.versionId,
    required this.versionNumber,
    required this.fileUrl,
    required this.parseStatus,
    required this.uploadedAt,
    required this.errorMessage,
  });

  factory TeacherMaterialVersionModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherMaterialVersionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherMaterialVersionModelToJson(this);
}

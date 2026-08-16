import 'package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_material_version_model.g.dart';

@JsonSerializable()
class StudentMaterialVersionModel {
  final String versionId;
  final int versionNumber;
  final String? fileUrl;
  final String parseStatus;
  final DateTime uploadedAt;
  final String? errorMessage;

  const StudentMaterialVersionModel({
    required this.versionId,
    required this.versionNumber,
    required this.fileUrl,
    required this.parseStatus,
    required this.uploadedAt,
    required this.errorMessage,
  });

  factory StudentMaterialVersionModel.fromJson(Map<String, dynamic> json) =>
      _$StudentMaterialVersionModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentMaterialVersionModelToJson(this);
}

extension StudentMaterialVersionModelMapper on StudentMaterialVersionModel {
  StudentMaterialVersion toEntity() => StudentMaterialVersion(
    versionId: versionId,
    versionNumber: versionNumber,
    fileUrl: fileUrl,
    parseStatus: parseStatus,
    uploadedAt: uploadedAt,
    errorMessage: errorMessage,
  );
}

import "package:draya_mobile/core/enums/material_type_enum.dart";
import "package:file_picker/file_picker.dart";

class MaterialsRequestModel {
  final String sectionId;
  final String title;
  final MaterialTypeEnum materialType;
  final PlatformFile file;

  const MaterialsRequestModel({
    required this.sectionId,
    required this.title,
    required this.materialType,
    required this.file,
  });

  factory MaterialsRequestModel.fromJson(Map<String, dynamic> json) {
    return MaterialsRequestModel(
      sectionId: json["sectionId"],
      title: json["title"],
      materialType: MaterialTypeEnum.fromJson(value: json["materialType"]),
      file: json["file"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sectionId": sectionId,
      "title": title,
      "materialType": materialType.name,
      "file": file,
    };
  }
}

import 'package:file_picker/file_picker.dart';

class MaterialsRequestModel {
  final String title;
  final String materialType;
  final PlatformFile file;

  const MaterialsRequestModel({
    required this.title,
    required this.materialType,
    required this.file,
  });

  factory MaterialsRequestModel.fromJson(Map<String, dynamic> json) {
    return MaterialsRequestModel(
      title: json["title"],
      materialType: json["materialType"],
      file: json["file"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "materialType": materialType,
      "file": file,
    };
  }
}

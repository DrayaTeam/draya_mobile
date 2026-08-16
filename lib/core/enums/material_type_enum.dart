enum MaterialTypeEnum {
  video(name: "Video"),
  pdf(name: "PDF"),
  docx(name: "DOCX"),
  pptx(name: "PPTX"),
  image(name: "Image");

  final String name;
  const MaterialTypeEnum({required this.name});

  static MaterialTypeEnum fromJson({required String value}) {
    return MaterialTypeEnum.values.firstWhere(
      (element) {
        return element.name.toLowerCase() == value.toLowerCase();
      },
      orElse: () {
        throw ArgumentError("نوع الملف غير مدعوم");
      },
    );
  }

  static MaterialTypeEnum fromExtension({required String extension}) {
    switch (extension.toLowerCase()) {
      case 'mp4':
      case 'mov':
      case 'mkv':
        return MaterialTypeEnum.video;
      case 'pdf':
        return MaterialTypeEnum.pdf;
      case 'docx':
        return MaterialTypeEnum.docx;
      case 'pptx':
        return MaterialTypeEnum.pptx;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
        return MaterialTypeEnum.image;
      default:
        throw ArgumentError("نوع الملف غير مدعوم");
    }
  }
}

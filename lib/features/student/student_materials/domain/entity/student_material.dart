class StudentMaterialVersion {
  final String versionId;
  final int versionNumber;
  final String? fileUrl;
  final String parseStatus;
  final DateTime uploadedAt;
  final String? errorMessage;

  const StudentMaterialVersion({
    required this.versionId,
    required this.versionNumber,
    required this.fileUrl,
    required this.parseStatus,
    required this.uploadedAt,
    required this.errorMessage,
  });

  bool get isReady => parseStatus.toLowerCase() == 'parsed';
  bool get hasFailed => parseStatus.toLowerCase() == 'failed';
}

class StudentMaterial {
  final String materialId;
  final String title;
  final String materialType;
  final DateTime createdAt;
  final StudentMaterialVersion currentVersion;

  const StudentMaterial({
    required this.materialId,
    required this.title,
    required this.materialType,
    required this.createdAt,
    required this.currentVersion,
  });

  bool get isVideo => materialType.toLowerCase() == 'video';
  bool get isPdf => materialType.toLowerCase() == 'pdf';
}

class StudentMaterialsPage {
  final List<StudentMaterial> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const StudentMaterialsPage({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
}

class SectionDocument {
  final String id;
  final String title;
  final String materialType;
  final DateTime createdAt;
  final String? fileUrl;

  const SectionDocument({
    required this.id,
    required this.title,
    required this.materialType,
    required this.createdAt,
    this.fileUrl,
  });

  bool get isPdf => materialType.toLowerCase() == "pdf";
  bool get hasFileUrl => fileUrl != null && fileUrl!.trim().isNotEmpty;
}

class SectionVideo {
  final String id;
  final String title;
  final String materialType;
  final DateTime createdAt;
  final String? videoUrl;
  final int? videoDurationInSeconds;

  const SectionVideo({
    required this.id,
    required this.title,
    required this.materialType,
    required this.createdAt,
    this.videoUrl,
    this.videoDurationInSeconds,
  });

  bool get hasVideoUrl => videoUrl != null && videoUrl!.trim().isNotEmpty;
}

class SectionExam {
  final String id;
  final String topic;
  final int questionsCount;
  final DateTime createdAt;
  final int? durationMinutes;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? allowedAttempts;

  const SectionExam({
    required this.id,
    required this.topic,
    required this.questionsCount,
    required this.createdAt,
    this.durationMinutes,
    this.startDate,
    this.endDate,
    this.allowedAttempts,
  });
}

class ClassroomSection {
  final String id;
  final String title;
  final String? description;
  final int order;
  final DateTime createdAt;
  final List<SectionDocument> documents;
  final List<SectionVideo> videos;
  final List<SectionExam> exams;

  const ClassroomSection({
    required this.id,
    required this.title,
    this.description,
    required this.order,
    required this.createdAt,
    this.documents = const [],
    this.videos = const [],
    this.exams = const [],
  });

  int get totalItemsCount =>
      documents.length + videos.length + exams.length;

  bool get isEmpty => totalItemsCount == 0;
}

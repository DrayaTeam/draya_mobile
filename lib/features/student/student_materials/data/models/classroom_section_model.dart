import "package:draya_mobile/features/student/student_materials/domain/entity/classroom_section.dart";
import "package:json_annotation/json_annotation.dart";

part "classroom_section_model.g.dart";

@JsonSerializable()
class SectionDocumentModel {
  final String id;
  final String title;
  final String materialType;
  final DateTime createdAt;
  final String? fileUrl;

  const SectionDocumentModel({
    required this.id,
    required this.title,
    required this.materialType,
    required this.createdAt,
    this.fileUrl,
  });

  factory SectionDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$SectionDocumentModelFromJson(json);

  Map<String, dynamic> toJson() => _$SectionDocumentModelToJson(this);

  SectionDocument toEntity() => SectionDocument(
        id: id,
        title: title,
        materialType: materialType,
        createdAt: createdAt,
        fileUrl: fileUrl,
      );
}

@JsonSerializable()
class SectionVideoModel {
  final String id;
  final String title;
  final String materialType;
  final DateTime createdAt;
  final String? videoUrl;
  final int? videoDurationInSeconds;

  const SectionVideoModel({
    required this.id,
    required this.title,
    required this.materialType,
    required this.createdAt,
    this.videoUrl,
    this.videoDurationInSeconds,
  });

  factory SectionVideoModel.fromJson(Map<String, dynamic> json) =>
      _$SectionVideoModelFromJson(json);

  Map<String, dynamic> toJson() => _$SectionVideoModelToJson(this);

  SectionVideo toEntity() => SectionVideo(
        id: id,
        title: title,
        materialType: materialType,
        createdAt: createdAt,
        videoUrl: videoUrl,
        videoDurationInSeconds: videoDurationInSeconds,
      );
}

@JsonSerializable()
class SectionExamModel {
  final String id;
  final String topic;
  final int questionsCount;
  final DateTime createdAt;
  final int? durationMinutes;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? allowedAttempts;

  const SectionExamModel({
    required this.id,
    required this.topic,
    required this.questionsCount,
    required this.createdAt,
    this.durationMinutes,
    this.startDate,
    this.endDate,
    this.allowedAttempts,
  });

  factory SectionExamModel.fromJson(Map<String, dynamic> json) =>
      _$SectionExamModelFromJson(json);

  Map<String, dynamic> toJson() => _$SectionExamModelToJson(this);

  SectionExam toEntity() => SectionExam(
        id: id,
        topic: topic,
        questionsCount: questionsCount,
        createdAt: createdAt,
        durationMinutes: durationMinutes,
        startDate: startDate,
        endDate: endDate,
        allowedAttempts: allowedAttempts,
      );
}

@JsonSerializable()
class ClassroomSectionModel {
  final String id;
  final String title;
  final String? description;
  final int order;
  final DateTime createdAt;
  @JsonKey(defaultValue: [])
  final List<SectionDocumentModel> documents;
  @JsonKey(defaultValue: [])
  final List<SectionVideoModel> videos;
  @JsonKey(defaultValue: [])
  final List<SectionExamModel> exams;

  const ClassroomSectionModel({
    required this.id,
    required this.title,
    this.description,
    required this.order,
    required this.createdAt,
    this.documents = const [],
    this.videos = const [],
    this.exams = const [],
  });

  factory ClassroomSectionModel.fromJson(Map<String, dynamic> json) =>
      _$ClassroomSectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassroomSectionModelToJson(this);

  ClassroomSection toEntity() => ClassroomSection(
        id: id,
        title: title,
        description: description,
        order: order,
        createdAt: createdAt,
        documents: documents.map((e) => e.toEntity()).toList(),
        videos: videos.map((e) => e.toEntity()).toList(),
        exams: exams.map((e) => e.toEntity()).toList(),
      );
}

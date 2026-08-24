import "package:draya_mobile/features/student/student_weak_topics/domain/entity/practice_exam_generation.dart";
import "package:json_annotation/json_annotation.dart";

part "practice_exam_generation_model.g.dart";

@JsonSerializable()
class PracticeExamGenerationResponseModel {
  @JsonKey(name: "generationId", defaultValue: "")
  final String generationId;

  @JsonKey(name: "message", defaultValue: "")
  final String message;

  const PracticeExamGenerationResponseModel({
    required this.generationId,
    required this.message,
  });

  factory PracticeExamGenerationResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PracticeExamGenerationResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PracticeExamGenerationResponseModelToJson(this);

  PracticeExamGeneration toEntity() {
    return PracticeExamGeneration(
      generationId: generationId,
      message: message,
    );
  }
}

@JsonSerializable()
class PracticeExamProgressModel {
  @JsonKey(name: "GenerationId", defaultValue: "")
  final String generationId;

  @JsonKey(name: "Status", defaultValue: "Pending")
  final String status;

  @JsonKey(name: "ErrorMessage")
  final String? errorMessage;

  @JsonKey(name: "ExamId")
  final String? examId;

  const PracticeExamProgressModel({
    required this.generationId,
    required this.status,
    this.errorMessage,
    this.examId,
  });

  factory PracticeExamProgressModel.fromJson(Map<String, dynamic> json) =>
      _$PracticeExamProgressModelFromJson(json);

  Map<String, dynamic> toJson() => _$PracticeExamProgressModelToJson(this);

  bool get isCompleted => status.toLowerCase() == "completed";
  bool get isFailed => status.toLowerCase() == "failed";
  bool get isGenerating => status.toLowerCase() == "generating";
  bool get isPending => status.toLowerCase() == "pending";
}

@JsonSerializable()
class PracticeExamGenerationStatusModel {
  @JsonKey(name: "id", defaultValue: "")
  final String id;

  @JsonKey(name: "status", defaultValue: 0)
  final int status;

  @JsonKey(name: "statusName", defaultValue: "")
  final String statusName;

  @JsonKey(name: "requestedCount", defaultValue: 0)
  final int requestedCount;

  @JsonKey(name: "generatedCount", defaultValue: 0)
  final int generatedCount;

  @JsonKey(name: "createdAt")
  final DateTime? createdAt;

  @JsonKey(name: "completedAt")
  final DateTime? completedAt;

  @JsonKey(name: "errorMessage")
  final String? errorMessage;

  @JsonKey(name: "examId")
  final String? examId;

  const PracticeExamGenerationStatusModel({
    required this.id,
    required this.status,
    required this.statusName,
    required this.requestedCount,
    required this.generatedCount,
    this.createdAt,
    this.completedAt,
    this.errorMessage,
    this.examId,
  });

  factory PracticeExamGenerationStatusModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PracticeExamGenerationStatusModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PracticeExamGenerationStatusModelToJson(this);

  PracticeExamGenerationStatus toEntity() {
    return PracticeExamGenerationStatus(
      id: id,
      status: status,
      statusName: statusName,
      requestedCount: requestedCount,
      generatedCount: generatedCount,
      createdAt: createdAt,
      completedAt: completedAt,
      errorMessage: errorMessage,
      examId: examId,
    );
  }
}

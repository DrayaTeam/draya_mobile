import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:json_annotation/json_annotation.dart";

part "attempt_models.g.dart";

@JsonSerializable()
class StartAttemptRequestModel {
  final String examId;

  const StartAttemptRequestModel({required this.examId});

  factory StartAttemptRequestModel.fromJson(Map<String, dynamic> json) =>
      _$StartAttemptRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$StartAttemptRequestModelToJson(this);
}

@JsonSerializable()
class StartAttemptResponseModel {
  final String attemptId;

  const StartAttemptResponseModel({required this.attemptId});

  factory StartAttemptResponseModel.fromJson(Map<String, dynamic> json) =>
      _$StartAttemptResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$StartAttemptResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SubmitAnswerRequestModel {
  final String examQuestionId;
  final String? answerText;
  final String? selectedOptionId;

  const SubmitAnswerRequestModel({
    required this.examQuestionId,
    this.answerText,
    this.selectedOptionId,
  });

  factory SubmitAnswerRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SubmitAnswerRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitAnswerRequestModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SubmitAttemptRequestModel {
  final String idempotencyKey;
  final List<SubmitAnswerRequestModel> answers;

  const SubmitAttemptRequestModel({
    required this.idempotencyKey,
    required this.answers,
  });

  factory SubmitAttemptRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SubmitAttemptRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitAttemptRequestModelToJson(this);
}

@JsonSerializable()
class SubmitAttemptResponseModel {
  final String? gradingJobId;
  final String? attemptId;
  final String? message;

  const SubmitAttemptResponseModel({
    this.gradingJobId,
    this.attemptId,
    this.message,
  });

  factory SubmitAttemptResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SubmitAttemptResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitAttemptResponseModelToJson(this);

  SubmitAttemptResponse toEntity() => SubmitAttemptResponse(
        gradingJobId: gradingJobId,
        attemptId: attemptId,
        message: message,
      );
}


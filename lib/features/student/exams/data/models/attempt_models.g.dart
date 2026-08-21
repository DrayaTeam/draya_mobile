// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attempt_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartAttemptRequestModel _$StartAttemptRequestModelFromJson(
  Map<String, dynamic> json,
) => StartAttemptRequestModel(examId: json['examId'] as String);

Map<String, dynamic> _$StartAttemptRequestModelToJson(
  StartAttemptRequestModel instance,
) => <String, dynamic>{'examId': instance.examId};

StartAttemptResponseModel _$StartAttemptResponseModelFromJson(
  Map<String, dynamic> json,
) => StartAttemptResponseModel(attemptId: json['attemptId'] as String);

Map<String, dynamic> _$StartAttemptResponseModelToJson(
  StartAttemptResponseModel instance,
) => <String, dynamic>{'attemptId': instance.attemptId};

SubmitAnswerRequestModel _$SubmitAnswerRequestModelFromJson(
  Map<String, dynamic> json,
) => SubmitAnswerRequestModel(
  examQuestionId: json['examQuestionId'] as String,
  answerText: json['answerText'] as String?,
  selectedOptionId: json['selectedOptionId'] as String?,
);

Map<String, dynamic> _$SubmitAnswerRequestModelToJson(
  SubmitAnswerRequestModel instance,
) => <String, dynamic>{
  'examQuestionId': instance.examQuestionId,
  'answerText': instance.answerText,
  'selectedOptionId': instance.selectedOptionId,
};

SubmitAttemptRequestModel _$SubmitAttemptRequestModelFromJson(
  Map<String, dynamic> json,
) => SubmitAttemptRequestModel(
  idempotencyKey: json['idempotencyKey'] as String,
  answers: (json['answers'] as List<dynamic>)
      .map((e) => SubmitAnswerRequestModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SubmitAttemptRequestModelToJson(
  SubmitAttemptRequestModel instance,
) => <String, dynamic>{
  'idempotencyKey': instance.idempotencyKey,
  'answers': instance.answers.map((e) => e.toJson()).toList(),
};

SubmitAttemptResponseModel _$SubmitAttemptResponseModelFromJson(
  Map<String, dynamic> json,
) => SubmitAttemptResponseModel(
  gradingJobId: json['gradingJobId'] as String?,
  attemptId: json['attemptId'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$SubmitAttemptResponseModelToJson(
  SubmitAttemptResponseModel instance,
) => <String, dynamic>{
  'gradingJobId': instance.gradingJobId,
  'attemptId': instance.attemptId,
  'message': instance.message,
};


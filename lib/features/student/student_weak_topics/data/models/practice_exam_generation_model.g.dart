// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_exam_generation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PracticeExamGenerationResponseModel
_$PracticeExamGenerationResponseModelFromJson(Map<String, dynamic> json) =>
    PracticeExamGenerationResponseModel(
      generationId: json['generationId'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );

Map<String, dynamic> _$PracticeExamGenerationResponseModelToJson(
  PracticeExamGenerationResponseModel instance,
) => <String, dynamic>{
  'generationId': instance.generationId,
  'message': instance.message,
};

PracticeExamProgressModel _$PracticeExamProgressModelFromJson(
  Map<String, dynamic> json,
) => PracticeExamProgressModel(
  generationId: json['GenerationId'] as String? ?? '',
  status: json['Status'] as String? ?? 'Pending',
  errorMessage: json['ErrorMessage'] as String?,
  examId: json['ExamId'] as String?,
);

Map<String, dynamic> _$PracticeExamProgressModelToJson(
  PracticeExamProgressModel instance,
) => <String, dynamic>{
  'GenerationId': instance.generationId,
  'Status': instance.status,
  'ErrorMessage': instance.errorMessage,
  'ExamId': instance.examId,
};

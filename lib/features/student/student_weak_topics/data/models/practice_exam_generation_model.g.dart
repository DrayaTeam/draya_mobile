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

PracticeExamGenerationStatusModel _$PracticeExamGenerationStatusModelFromJson(
  Map<String, dynamic> json,
) => PracticeExamGenerationStatusModel(
  id: json['id'] as String? ?? '',
  status: (json['status'] as num?)?.toInt() ?? 0,
  statusName: json['statusName'] as String? ?? '',
  requestedCount: (json['requestedCount'] as num?)?.toInt() ?? 0,
  generatedCount: (json['generatedCount'] as num?)?.toInt() ?? 0,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  errorMessage: json['errorMessage'] as String?,
  examId: json['examId'] as String?,
);

Map<String, dynamic> _$PracticeExamGenerationStatusModelToJson(
  PracticeExamGenerationStatusModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'statusName': instance.statusName,
  'requestedCount': instance.requestedCount,
  'generatedCount': instance.generatedCount,
  'createdAt': instance.createdAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'errorMessage': instance.errorMessage,
  'examId': instance.examId,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_exam_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionOptionModel _$QuestionOptionModelFromJson(Map<String, dynamic> json) =>
    QuestionOptionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool?,
    );

Map<String, dynamic> _$QuestionOptionModelToJson(
  QuestionOptionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'isCorrect': instance.isCorrect,
};

ExamQuestionModel _$ExamQuestionModelFromJson(Map<String, dynamic> json) =>
    ExamQuestionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      rubric: json['rubric'] as String?,
      options:
          (json['options'] as List<dynamic>?)
              ?.map(
                (e) => QuestionOptionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$ExamQuestionModelToJson(ExamQuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'type': instance.type,
      'difficulty': instance.difficulty,
      'rubric': instance.rubric,
      'options': instance.options,
    };

StudentExamModel _$StudentExamModelFromJson(Map<String, dynamic> json) =>
    StudentExamModel(
      id: json['id'] as String,
      classroomId: json['classroomId'] as String,
      sectionId: json['sectionId'] as String?,
      title: json['title'] as String,
      topic: json['topic'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map(
                (e) => ExamQuestionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$StudentExamModelToJson(StudentExamModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'classroomId': instance.classroomId,
      'sectionId': instance.sectionId,
      'title': instance.title,
      'topic': instance.topic,
      'createdAt': instance.createdAt.toIso8601String(),
      'questions': instance.questions,
    };

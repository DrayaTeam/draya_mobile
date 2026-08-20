import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:json_annotation/json_annotation.dart";

part "student_exam_models.g.dart";

@JsonSerializable()
class QuestionOptionModel {
  final String id;
  final String text;
  final bool? isCorrect;

  const QuestionOptionModel({
    required this.id,
    required this.text,
    this.isCorrect,
  });

  factory QuestionOptionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionOptionModelToJson(this);

  QuestionOption toEntity() => QuestionOption(
        id: id,
        text: text,
      );
}

@JsonSerializable()
class ExamQuestionModel {
  final String id;
  final String text;
  final String type;
  final String difficulty;
  final String? rubric;
  @JsonKey(defaultValue: [])
  final List<QuestionOptionModel> options;

  const ExamQuestionModel({
    required this.id,
    required this.text,
    required this.type,
    required this.difficulty,
    this.rubric,
    this.options = const [],
  });

  factory ExamQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$ExamQuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamQuestionModelToJson(this);

  ExamQuestion toEntity() => ExamQuestion(
        id: id,
        text: text,
        type: QuestionType.fromString(type),
        difficulty: difficulty,
        rubric: rubric,
        options: options.map((e) => e.toEntity()).toList(),
      );
}

@JsonSerializable()
class StudentExamModel {
  final String id;
  final String classroomId;
  final String? sectionId;
  final String title;
  final String topic;
  final DateTime createdAt;
  @JsonKey(defaultValue: [])
  final List<ExamQuestionModel> questions;

  const StudentExamModel({
    required this.id,
    required this.classroomId,
    this.sectionId,
    required this.title,
    required this.topic,
    required this.createdAt,
    this.questions = const [],
  });

  factory StudentExamModel.fromJson(Map<String, dynamic> json) =>
      _$StudentExamModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentExamModelToJson(this);

  StudentExam toEntity() => StudentExam(
        id: id,
        classroomId: classroomId,
        sectionId: sectionId,
        title: title,
        topic: topic,
        createdAt: createdAt,
        questions: questions.map((e) => e.toEntity()).toList(),
      );
}

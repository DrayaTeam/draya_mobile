import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:json_annotation/json_annotation.dart";

part "student_exam_models.g.dart";

@JsonSerializable()
class AttemptSummaryModel {
  final String id;
  @JsonKey(defaultValue: 0.0)
  final double finalScore;
  @JsonKey(defaultValue: 0.0)
  final double maxScore;
  @JsonKey(defaultValue: false)
  final bool needsTeacherReview;
  final DateTime? submittedAt;
  final DateTime? startedAt;

  const AttemptSummaryModel({
    required this.id,
    this.finalScore = 0.0,
    this.maxScore = 0.0,
    this.needsTeacherReview = false,
    this.submittedAt,
    this.startedAt,
  });

  factory AttemptSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$AttemptSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttemptSummaryModelToJson(this);

  ExamAttemptSummary toEntity() => ExamAttemptSummary(
        id: id,
        finalScore: finalScore,
        maxScore: maxScore,
        needsTeacherReview: needsTeacherReview,
        submittedAt: submittedAt,
        startedAt: startedAt,
      );
}

@JsonSerializable()
class StudentExamOverviewModel {
  final String id;
  final String classroomId;
  final String? sectionId;
  final String title;
  final String topic;
  final int? durationMinutes;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? allowedAttempts;
  final DateTime createdAt;
  @JsonKey(defaultValue: false)
  final bool hasSubmitted;
  final String? attemptStatus;
  final double? latestScore;
  final double? maxScore;
  @JsonKey(defaultValue: 0)
  final int usedAttempts;
  @JsonKey(defaultValue: [])
  final List<AttemptSummaryModel> attempts;

  const StudentExamOverviewModel({
    required this.id,
    required this.classroomId,
    this.sectionId,
    required this.title,
    required this.topic,
    required this.createdAt,
    this.durationMinutes,
    this.startDate,
    this.endDate,
    this.allowedAttempts,
    this.hasSubmitted = false,
    this.attemptStatus,
    this.latestScore,
    this.maxScore,
    this.usedAttempts = 0,
    this.attempts = const [],
  });

  factory StudentExamOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$StudentExamOverviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentExamOverviewModelToJson(this);

  StudentExamOverview toEntity() => StudentExamOverview(
        id: id,
        classroomId: classroomId,
        sectionId: sectionId,
        title: title,
        topic: topic,
        allowedAttempts: allowedAttempts,
        usedAttempts: usedAttempts,
        hasSubmitted: hasSubmitted,
        attemptStatus: attemptStatus,
        latestScore: latestScore,
        maxScore: maxScore,
        attempts: attempts.map((e) => e.toEntity()).toList(),
      );
}

@JsonSerializable()
class StudentExamsPageModel {
  @JsonKey(defaultValue: [])
  final List<StudentExamOverviewModel> items;

  const StudentExamsPageModel({this.items = const []});

  factory StudentExamsPageModel.fromJson(Map<String, dynamic> json) =>
      _$StudentExamsPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentExamsPageModelToJson(this);

  List<StudentExamOverview> toEntities() =>
      items.map((e) => e.toEntity()).toList();
}

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
  final int? durationMinutes;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? allowedAttempts;
  @JsonKey(defaultValue: [])
  final List<ExamQuestionModel> questions;

  const StudentExamModel({
    required this.id,
    required this.classroomId,
    this.sectionId,
    required this.title,
    required this.topic,
    required this.createdAt,
    this.durationMinutes,
    this.startDate,
    this.endDate,
    this.allowedAttempts,
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
        durationMinutes: durationMinutes,
        startDate: startDate,
        endDate: endDate,
        allowedAttempts: allowedAttempts,
        questions: questions.map((e) => e.toEntity()).toList(),
      );
}

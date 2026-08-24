import "package:draya_mobile/features/student/exams_history/domain/entity/student_exam_history.dart";
import "package:json_annotation/json_annotation.dart";

part "student_exams_history_models.g.dart";

@JsonSerializable()
class AttemptSummaryModel {
  final String id;
  @JsonKey(defaultValue: 0.0)
  final double finalScore;
  final double? maxScore;
  @JsonKey(defaultValue: false)
  final bool needsTeacherReview;
  @JsonKey(defaultValue: false)
  final bool isFinalized;
  final DateTime? startedAt;
  final DateTime? submittedAt;

  const AttemptSummaryModel({
    required this.id,
    this.finalScore = 0.0,
    this.maxScore,
    this.needsTeacherReview = false,
    this.isFinalized = false,
    this.startedAt,
    this.submittedAt,
  });

  factory AttemptSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$AttemptSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttemptSummaryModelToJson(this);

  AttemptSummary toEntity() => AttemptSummary(
        id: id,
        finalScore: finalScore,
        maxScore: maxScore,
        needsTeacherReview: needsTeacherReview,
        isFinalized: isFinalized,
        startedAt: startedAt,
        submittedAt: submittedAt,
      );
}

@JsonSerializable()
class StudentExamWithAttemptsModel {
  final String id;
  final String title;
  final String? classroomId;
  final String? classroomName;
  final double? latestScore;
  final double? maxScore;
  @JsonKey(defaultValue: 0)
  final int usedAttempts;
  final int? allowedAttempts;
  @JsonKey(defaultValue: false)
  final bool hasSubmitted;
  final String? attemptStatus;
  @JsonKey(defaultValue: [])
  final List<AttemptSummaryModel> attempts;

  const StudentExamWithAttemptsModel({
    required this.id,
    required this.title,
    this.classroomId,
    this.classroomName,
    this.latestScore,
    this.maxScore,
    this.usedAttempts = 0,
    this.allowedAttempts,
    this.hasSubmitted = false,
    this.attemptStatus,
    this.attempts = const [],
  });

  factory StudentExamWithAttemptsModel.fromJson(Map<String, dynamic> json) =>
      _$StudentExamWithAttemptsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentExamWithAttemptsModelToJson(this);

  StudentExamWithAttempts toEntity() => StudentExamWithAttempts(
        id: id,
        title: title,
        classroomId: classroomId,
        classroomName: classroomName,
        latestScore: latestScore,
        maxScore: maxScore,
        usedAttempts: usedAttempts,
        allowedAttempts: allowedAttempts,
        hasSubmitted: hasSubmitted,
        attemptStatus: ExamAttemptStatus.fromString(attemptStatus),
        attempts: attempts.map((e) => e.toEntity()).toList(),
      );
}

@JsonSerializable()
class StudentExamsHistoryPagedResultModel {
  @JsonKey(defaultValue: [])
  final List<StudentExamWithAttemptsModel> items;
  @JsonKey(defaultValue: 1)
  final int page;
  @JsonKey(defaultValue: 20)
  final int pageSize;
  @JsonKey(defaultValue: 0)
  final int totalCount;

  const StudentExamsHistoryPagedResultModel({
    this.items = const [],
    this.page = 1,
    this.pageSize = 20,
    this.totalCount = 0,
  });

  factory StudentExamsHistoryPagedResultModel.fromJson(
          Map<String, dynamic> json) =>
      _$StudentExamsHistoryPagedResultModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$StudentExamsHistoryPagedResultModelToJson(this);

  StudentExamsHistoryPage toEntity() => StudentExamsHistoryPage(
        items: items.map((e) => e.toEntity()).toList(),
        page: page,
        pageSize: pageSize,
        totalCount: totalCount,
      );
}

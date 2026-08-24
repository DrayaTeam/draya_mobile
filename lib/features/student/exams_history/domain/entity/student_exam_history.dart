enum ExamAttemptStatus {
  notStarted,
  inProgress,
  pendingGrading,
  completed,
  unknown;

  static ExamAttemptStatus fromString(String? status) {
    switch (status?.toLowerCase().trim()) {
      case "notstarted":
        return ExamAttemptStatus.notStarted;
      case "inprogress":
        return ExamAttemptStatus.inProgress;
      case "pendinggrading":
        return ExamAttemptStatus.pendingGrading;
      case "completed":
        return ExamAttemptStatus.completed;
      default:
        return ExamAttemptStatus.unknown;
    }
  }

  String toDisplayString() {
    switch (this) {
      case ExamAttemptStatus.notStarted:
        return "لم يبدأ";
      case ExamAttemptStatus.inProgress:
        return "قيد الأداء";
      case ExamAttemptStatus.pendingGrading:
        return "بانتظار التصحيح";
      case ExamAttemptStatus.completed:
        return "مكتمل";
      case ExamAttemptStatus.unknown:
        return "غير معروف";
    }
  }
}

class AttemptSummary {
  final String id;
  final double finalScore;
  final double? maxScore;
  final bool needsTeacherReview;
  final bool isFinalized;
  final DateTime? startedAt;
  final DateTime? submittedAt;

  const AttemptSummary({
    required this.id,
    this.finalScore = 0.0,
    this.maxScore,
    this.needsTeacherReview = false,
    this.isFinalized = false,
    this.startedAt,
    this.submittedAt,
  });

  bool get hasMaxScore => maxScore != null && maxScore! > 0;

  double get scorePercent => hasMaxScore
      ? ((finalScore / maxScore!) * 100).clamp(0.0, 100.0)
      : finalScore.clamp(0.0, 100.0);
}

class StudentExamWithAttempts {
  final String id;
  final String title;
  final String? classroomId;
  final String? classroomName;
  final double? latestScore;
  final double? maxScore;
  final int usedAttempts;
  final int? allowedAttempts;
  final bool hasSubmitted;
  final ExamAttemptStatus attemptStatus;
  final List<AttemptSummary> attempts;

  const StudentExamWithAttempts({
    required this.id,
    required this.title,
    this.classroomId,
    this.classroomName,
    this.latestScore,
    this.maxScore,
    this.usedAttempts = 0,
    this.allowedAttempts,
    this.hasSubmitted = false,
    this.attemptStatus = ExamAttemptStatus.unknown,
    this.attempts = const [],
  });

  bool get canResume =>
      !hasSubmitted && attemptStatus == ExamAttemptStatus.inProgress;

  bool get canRetake =>
      allowedAttempts == null || usedAttempts < allowedAttempts!;

  bool get hasMaxScore => maxScore != null && maxScore! > 0;

  double? get latestScorePercent {
    if (latestScore == null) return null;
    return hasMaxScore
        ? ((latestScore! / maxScore!) * 100).clamp(0.0, 100.0)
        : latestScore!.clamp(0.0, 100.0);
  }

  AttemptSummary? get bestAttempt {
    if (attempts.isEmpty) return null;
    return attempts.reduce(
      (a, b) => a.scorePercent >= b.scorePercent ? a : b,
    );
  }
}

class StudentExamsHistoryPage {
  final List<StudentExamWithAttempts> items;
  final int page;
  final int pageSize;
  final int totalCount;

  const StudentExamsHistoryPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });
}

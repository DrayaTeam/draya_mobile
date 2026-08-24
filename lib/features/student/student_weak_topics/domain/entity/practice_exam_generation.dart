class PracticeExamGeneration {
  final String generationId;
  final String message;

  const PracticeExamGeneration({
    required this.generationId,
    required this.message,
  });
}

class PracticeExamGenerationStatus {
  final String id;
  final int status;
  final String statusName;
  final int requestedCount;
  final int generatedCount;
  final DateTime? createdAt;
  final DateTime? completedAt;
  final String? errorMessage;
  final String? examId;

  const PracticeExamGenerationStatus({
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

  bool get isPending => status == 0;
  bool get isRetrieving => status == 1;
  bool get isGenerating => status == 2;
  bool get isValidating => status == 3;
  bool get isCompleted => status == 4 || status == 5;
  bool get isFailed => status == 6 || status == 7;

  bool get isFinished => isCompleted || isFailed;
}

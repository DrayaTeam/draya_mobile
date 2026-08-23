class OverrideAnswerScoreParams {
  final String attemptId;
  final String answerId;
  final double newScore;

  const OverrideAnswerScoreParams({
    required this.attemptId,
    required this.answerId,
    required this.newScore,
  });
}

abstract final class StudentChannelApiConstants {
  static const String classroomQuestions =
      "classrooms/{classroomId}/questions";
  static const String questionById =
      "classrooms/{classroomId}/questions/{questionId}";
  static const String createQuestion =
      "classrooms/{classroomId}/questions";
  static const String createReply =
      "classrooms/{classroomId}/questions/{questionId}/replies";
  static const String voteQuestion =
      "classrooms/{classroomId}/questions/{questionId}/vote";
  static const String unvoteQuestion =
      "classrooms/{classroomId}/questions/{questionId}/vote";
}

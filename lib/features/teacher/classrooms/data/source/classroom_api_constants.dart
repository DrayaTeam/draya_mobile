abstract final class ClassroomApiConstants {
  static const String classrooms = "/classrooms";
  static const String classroomId = "classroomId";
  static const String classroomById = "/classrooms/{$classroomId}";
  static const String regenerateCode =
      "/classrooms/{$classroomId}/regenerate-code";
  static const String students = "/classrooms/{$classroomId}/students";
  static const String pricing = "/classrooms/{$classroomId}/pricing";
  static const String classroomTypes = "/classrooms/types";
  static const String gradeLevels = "/classrooms/grade-levels";
}

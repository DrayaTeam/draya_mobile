class QuestionRequirementModel {
  final String type;
  final int count;

  const QuestionRequirementModel({
    required this.type,
    required this.count,
  });

  Map<String, dynamic> toJson() => {
        "type": type,
        "count": count,
      };

  factory QuestionRequirementModel.fromJson(Map<String, dynamic> json) =>
      QuestionRequirementModel(
        type: json["type"] as String? ?? "MCQ",
        count: json["count"] as int? ?? 1,
      );
}

class ExamGenerationRequestModel {
  final String classroomId;
  final String sectionId;
  final String topic;
  final String difficultyLevel;
  final List<QuestionRequirementModel> questionRequirements;
  final String? teacherInstructions;
  final String idempotencyKey;
  final int? allowedAttempts;
  final int? durationMinutes;
  final DateTime? startDate;
  final DateTime? endDate;

  const ExamGenerationRequestModel({
    required this.classroomId,
    required this.sectionId,
    required this.topic,
    required this.difficultyLevel,
    required this.questionRequirements,
    this.teacherInstructions,
    required this.idempotencyKey,
    this.allowedAttempts,
    this.durationMinutes,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() => {
        "classroomId": classroomId,
        "sectionId": sectionId,
        "topic": topic,
        "difficultyLevel": difficultyLevel,
        "questionRequirements":
            questionRequirements.map((e) => e.toJson()).toList(),
        if (teacherInstructions != null && teacherInstructions!.isNotEmpty)
          "teacherInstructions": teacherInstructions,
        "idempotencyKey": idempotencyKey,
        if (allowedAttempts != null) "allowedAttempts": allowedAttempts,
        if (durationMinutes != null) "durationMinutes": durationMinutes,
        if (startDate != null) "startDate": startDate!.toIso8601String(),
        if (endDate != null) "endDate": endDate!.toIso8601String(),
      };
}

class ExamGenerationResponseModel {
  final String generationId;
  final String? message;

  const ExamGenerationResponseModel({
    required this.generationId,
    this.message,
  });

  factory ExamGenerationResponseModel.fromJson(Map<String, dynamic> json) =>
      ExamGenerationResponseModel(
        generationId: json["generationId"] as String? ?? "",
        message: json["message"] as String?,
      );
}

class ExamGenerationStatusModel {
  final String id;
  final int status;
  final String statusName;
  final int requestedCount;
  final int generatedCount;
  final DateTime? createdAt;
  final DateTime? completedAt;
  final String? errorMessage;
  final String? examId;

  const ExamGenerationStatusModel({
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
  bool get isCompleted => status == 4;
  bool get isCompletedWithWarning => status == 5;
  bool get isDataUnavailable => status == 6;
  bool get isFailed => status == 7;

  bool get isFinished =>
      isCompleted || isCompletedWithWarning || isDataUnavailable || isFailed;

  String get localizedStatusArabic {
    switch (status) {
      case 0:
        return "في قائمة الانتظار...";
      case 1:
        return "جاري استرجاع المواد والمصادر العلمية (RAG)...";
      case 2:
        return "الذكاء الاصطناعي يقوم بصياغة الأسئلة الآن...";
      case 3:
        return "جاري التحقق من جودة وصحة الأسئلة...";
      case 4:
        return "تم إنشاء الامتحان بنجاح!";
      case 5:
        return "تم إنشاء الامتحان (مع وجود بعض الملاحظات)";
      case 6:
        return "عذراً، لم يتم العثور على مواد كافية لهذا القسم";
      case 7:
        return "فشلت عملية إنشاء الامتحان: ${errorMessage ?? ''}";
      default:
        return statusName;
    }
  }

  factory ExamGenerationStatusModel.fromJson(Map<String, dynamic> json) =>
      ExamGenerationStatusModel(
        id: json["id"] as String? ?? "",
        status: json["status"] as int? ?? 0,
        statusName: json["statusName"] as String? ?? "",
        requestedCount: json["requestedCount"] as int? ?? 0,
        generatedCount: json["generatedCount"] as int? ?? 0,
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"] as String)
            : null,
        completedAt: json["completedAt"] != null
            ? DateTime.tryParse(json["completedAt"] as String)
            : null,
        errorMessage: json["errorMessage"] as String?,
        examId: json["examId"] as String?,
      );
}

class TeacherExamQuestionOptionModel {
  final String? id;
  final String text;
  final bool isCorrect;

  const TeacherExamQuestionOptionModel({
    this.id,
    required this.text,
    this.isCorrect = false,
  });

  TeacherExamQuestionOptionModel copyWith({
    String? id,
    String? text,
    bool? isCorrect,
  }) {
    return TeacherExamQuestionOptionModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        "text": text,
        "isCorrect": isCorrect,
      };

  factory TeacherExamQuestionOptionModel.fromJson(Map<String, dynamic> json) =>
      TeacherExamQuestionOptionModel(
        id: json["id"]?.toString(),
        text: json["text"]?.toString() ?? "",
        isCorrect: json["isCorrect"] == true ||
            json["isCorrect"]?.toString().toLowerCase() == "true" ||
            json["isCorrect"] == 1,
      );
}

class TeacherExamQuestionModel {
  final String id;
  final String text;
  final String type;
  final String difficulty;
  final String? rubric;
  final List<TeacherExamQuestionOptionModel> options;
  final List<String> sourceChunkIds;

  const TeacherExamQuestionModel({
    required this.id,
    required this.text,
    required this.type,
    required this.difficulty,
    this.rubric,
    this.options = const [],
    this.sourceChunkIds = const [],
  });

  TeacherExamQuestionModel copyWith({
    String? id,
    String? text,
    String? type,
    String? difficulty,
    String? rubric,
    List<TeacherExamQuestionOptionModel>? options,
    List<String>? sourceChunkIds,
  }) {
    return TeacherExamQuestionModel(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      rubric: rubric ?? this.rubric,
      options: options ?? this.options,
      sourceChunkIds: sourceChunkIds ?? this.sourceChunkIds,
    );
  }

  Map<String, dynamic> toJson() => {
        "text": text,
        "type": type,
        "difficulty": difficulty,
        "rubric": rubric,
        "sourceChunkIds": sourceChunkIds,
        "options": options.map((e) => e.toJson()).toList(),
      };

  factory TeacherExamQuestionModel.fromJson(Map<String, dynamic> json) {
    return TeacherExamQuestionModel(
      id: json["id"] as String? ?? "",
      text: json["text"] as String? ?? "",
      type: json["type"] as String? ?? "MultipleChoice",
      difficulty: json["difficulty"] as String? ?? "easy",
      rubric: json["rubric"] as String?,
      options: (json["options"] as List<dynamic>?)
              ?.map((e) => TeacherExamQuestionOptionModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
      sourceChunkIds: _parseSourceChunkIds(json["sourceChunkIds"]),
    );
  }
}

List<String> _parseSourceChunkIds(dynamic raw) {
  if (raw == null) return [];
  if (raw is List) {
    return raw.map((e) => e.toString()).toList();
  }
  if (raw is String) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return [];
    return trimmed
        .split(",")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
  return [];
}

class TeacherExamDetailModel {
  final String id;
  final String classroomId;
  final String? sectionId;
  final String title;
  final String topic;
  final DateTime? createdAt;
  final int? durationMinutes;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? allowedAttempts;
  final List<TeacherExamQuestionModel> questions;

  const TeacherExamDetailModel({
    required this.id,
    required this.classroomId,
    this.sectionId,
    required this.title,
    required this.topic,
    this.createdAt,
    this.durationMinutes,
    this.startDate,
    this.endDate,
    this.allowedAttempts,
    this.questions = const [],
  });

  factory TeacherExamDetailModel.fromJson(Map<String, dynamic> json) {
    return TeacherExamDetailModel(
      id: json["id"]?.toString() ?? "",
      classroomId: json["classroomId"]?.toString() ?? "",
      sectionId: json["sectionId"]?.toString(),
      title: json["title"]?.toString() ?? "",
      topic: json["topic"]?.toString() ?? "",
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString())
          : null,
      durationMinutes: json["durationMinutes"] is int
          ? json["durationMinutes"] as int
          : int.tryParse(json["durationMinutes"]?.toString() ?? ""),
      startDate: json["startDate"] != null
          ? DateTime.tryParse(json["startDate"].toString())
          : null,
      endDate: json["endDate"] != null
          ? DateTime.tryParse(json["endDate"].toString())
          : null,
      allowedAttempts: json["allowedAttempts"] is int
          ? json["allowedAttempts"] as int
          : int.tryParse(json["allowedAttempts"]?.toString() ?? ""),
      questions: (json["questions"] as List<dynamic>?)
              ?.map((e) => TeacherExamQuestionModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RefinedQuestionResponseModel {
  final String text;
  final String type;
  final String difficulty;
  final String? rubric;
  final List<TeacherExamQuestionOptionModel> options;
  final List<String> sourceChunkIds;

  const RefinedQuestionResponseModel({
    required this.text,
    required this.type,
    required this.difficulty,
    this.rubric,
    this.options = const [],
    this.sourceChunkIds = const [],
  });

  factory RefinedQuestionResponseModel.fromJson(Map<String, dynamic> json) {
    return RefinedQuestionResponseModel(
      text: json["text"] as String? ?? "",
      type: json["type"] as String? ?? "MultipleChoice",
      difficulty: json["difficulty"] as String? ?? "medium",
      rubric: json["rubric"] as String?,
      options: (json["options"] as List<dynamic>?)
              ?.map((e) => TeacherExamQuestionOptionModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
      sourceChunkIds: _parseSourceChunkIds(json["sourceChunkIds"]),
    );
  }
}

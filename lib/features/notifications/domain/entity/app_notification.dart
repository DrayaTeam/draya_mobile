enum AppNotificationType {
  info,
  success,
  warning,
  error;

  static AppNotificationType fromName(String? name) {
    switch (name?.toLowerCase()) {
      case "success":
        return AppNotificationType.success;
      case "warning":
        return AppNotificationType.warning;
      case "error":
        return AppNotificationType.error;
      default:
        return AppNotificationType.info;
    }
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final AppNotificationType type;
  final String? link;
  final DateTime createdAt;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.link,
    this.isRead = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json["id"] ?? "").toString(),
      title: (json["title"] ?? "").toString(),
      message: (json["message"] ?? "").toString(),
      type: AppNotificationType.fromName(json["type"]?.toString()),
      link: json["link"]?.toString(),
      isRead: json["read"] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json["createdAt"]?.toString() ?? "") ??
          DateTime.now(),
    );
  }

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      type: type,
      link: link,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

class AnswerScoreOverriddenPayload {
  final String attemptId;
  final String answerId;
  final double newScore;

  const AnswerScoreOverriddenPayload({
    required this.attemptId,
    required this.answerId,
    required this.newScore,
  });

  factory AnswerScoreOverriddenPayload.fromJson(Map<String, dynamic> json) {
    return AnswerScoreOverriddenPayload(
      attemptId: (json["attemptId"] ?? "").toString(),
      answerId: (json["answerId"] ?? "").toString(),
      newScore:
          (json["newScore"] as num?)?.toDouble() ??
          double.tryParse(json["newScore"]?.toString() ?? "") ??
          0,
    );
  }
}

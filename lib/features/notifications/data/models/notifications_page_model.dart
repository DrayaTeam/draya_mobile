import "package:draya_mobile/features/notifications/domain/entity/app_notification.dart";

class NotificationsPageModel {
  final List<AppNotification> items;
  final int unreadCount;
  final int totalCount;

  const NotificationsPageModel({
    required this.items,
    required this.unreadCount,
    required this.totalCount,
  });

  factory NotificationsPageModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json["items"] as List<dynamic>? ?? const [];
    return NotificationsPageModel(
      items: rawItems
          .whereType<Map>()
          .map((item) => AppNotification.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      unreadCount: (json["unreadCount"] as num?)?.toInt() ?? 0,
      totalCount: (json["totalCount"] as num?)?.toInt() ?? rawItems.length,
    );
  }
}

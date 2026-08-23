import "package:flutter_local_notifications/flutter_local_notifications.dart";

/// Shows system (heads-up / tray) notifications for real-time events
/// received via SignalR, so the user is alerted even when the app is
/// in the background or on a different screen.
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = "draya_notifications";
  static const String _channelName = "إشعارات دراية";
  static const String _channelDescription =
      "إشعارات الامتحانات والتقارير والمواد الدراسية";

  bool _initialized = false;
  int _idCounter = 0;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    const settings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(settings: settings);
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.requestNotificationsPermission();

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Displays a local system notification.
  ///
  /// [id] can be used to group/replace notifications; pass null to get a
  /// unique id per call.
  Future<void> show({
    required String title,
    required String body,
    int? id,
  }) async {
    if (!_initialized) await init();

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        category: AndroidNotificationCategory.status,
        ticker: title,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
      ),
    );

    await _plugin.show(
      id: id ?? _idCounter++,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}

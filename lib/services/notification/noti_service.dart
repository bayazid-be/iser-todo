import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  static int id = 0;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // Initialize
  Future<void> initNotification() async {
    if (_isInitialized) return;
    // prepaired android init settings
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // prepaired ios init settings
    const initSettingsIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // init Settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIos,
    );
    await notificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('-----ok----your details is : ');
        print(details.payload);
      },
    );
    print('---ini noti properly --');
  }

  // Notification Details
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel_id',
        'Default Channel',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // Show Notification
  Future<void> showNotification({
    required int id_,
    required String? title,
    required String? body,
  }) async {
    print('-----show noti is called');
    return notificationPlugin.show(
      id++,
      title,
      body,
      notificationDetails(),
      payload: 'ha ha payload',
    );
  }
}

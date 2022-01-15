import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  static Future<void> localNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    NotificationDetails _notificationDetails =
        await NotificationApi._notificationDetails();
    _notification.show(id, title, body, _notificationDetails, payload: payload);
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notif{
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('launcher_icon');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});
    var initializationSettingsLinux= const LinuxInitializationSettings(defaultActionName: 'Open notification');

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS,linux: initializationSettingsLinux);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  static notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('chanelId2', 'chanelName2',
            importance: Importance.min,
            priority:Priority.low,
            ongoing: true,
            visibility: NotificationVisibility.public,
            autoCancel: false,
            playSound: false),
        iOS: DarwinNotificationDetails());
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
   static void cacelSingleNotification()=> notificationsPlugin.cancel(0);
}
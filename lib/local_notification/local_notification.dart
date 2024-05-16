import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart' as tz;

////local notification--------->>

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initCall();
  runApp(const MaterialApp(
    home: LocalNotificationDemo(),
    debugShowCheckedModeBanner: false,
  ));
}

initCall() async {
  initializeTimeZones();
  AndroidInitializationSettings androidSettings =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true);
  InitializationSettings initializationSettings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);
  bool? initialized = await notificationsPlugin.initialize(
      initializationSettings, onDidReceiveNotificationResponse: (response) {
    log(response.payload.toString());
  });
  log("Notifications: $initialized");
}

class LocalNotificationDemo extends StatefulWidget {
  const LocalNotificationDemo({super.key});

  @override
  State<LocalNotificationDemo> createState() => _LocalNotificationDemoState();
}

class _LocalNotificationDemoState extends State<LocalNotificationDemo> {
//send notification
  void sendNotification() async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
            "notifications-youtube", "YouTube Notifications",
            priority: Priority.max, importance: Importance.max);

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notiDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    DateTime scheduleDate = DateTime.now().add(const Duration(seconds: 5));

    await notificationsPlugin.zonedSchedule(
        0,
        "This is Title",
        "This is description",
        tz.TZDateTime.from(scheduleDate, tz.local),
        notiDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        // ignore: deprecated_member_use
        androidAllowWhileIdle: true,
        payload: "notification-payload");
  }

//scheduleNotification
  void scheduleNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    notificationsPlugin.periodicallyShow(
      0,
      title,
      body,
      RepeatInterval.everyMinute,
      notificationDetails,
    );
  }

//checkForNotification
  void checkForNotification() async {
    NotificationAppLaunchDetails? details =
        await notificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null) {
      if (details.didNotificationLaunchApp) {
        NotificationResponse? response = details.notificationResponse;

        if (response != null) {
          String? payload = response.payload;
          log("Notification Payload: $payload");
        }
      }
    }
  }

//stopNotification
  void stopNotification() async {
    notificationsPlugin.cancel(0);
  }

  @override
  void initState() {
    super.initState();
    checkForNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: sendNotification,
                  child: const Text("Send Notification")),
              ElevatedButton(
                  onPressed: () {
                    scheduleNotification(
                      "scheduleNotification",
                      "body",
                    );
                  },
                  child: const Text("Schedule Notification")),
              ElevatedButton(
                  onPressed: () {
                    stopNotification();
                  },
                  child: const Text("Stop Notification"))
            ],
          ),
        ),
      ),
    );
  }
}

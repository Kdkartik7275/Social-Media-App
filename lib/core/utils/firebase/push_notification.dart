import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static Future requestNotificationPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission Granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Permission provisional Granted");
    } else {
      AppSettings.openAppSettings();
      print("Permission denied");
    }
  }

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initialSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    await _flutterLocalNotificationsPlugin.initialize(initialSettings,
        onDidReceiveBackgroundNotificationResponse: (payload) {
      handleMessage(context, message);
    }, onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {}
      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  void showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'social_x',
      'channelName',
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
    );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<String> getToken() async {
    String? token = await messaging.getToken();

    return token!;
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  @pragma('vm:entry-point')
  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'profile') {
      print("New Follower ---------");
    } else {
      print("Post Liked ---------------");
    }
  }

  Future<void> sendPushNotification(
      {required String sendTo,
      required String title,
      required Map<String, dynamic> payload,
      required String body}) async {
    var data = {
      'to': sendTo,
      'priority': 'high',
      'notification': {
        'title': title,
        'body': body,
        'android_channel_id': 'social_x'
      },
      'data': payload,
    };
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=AAAAlkiu2Uo:APA91bHRPUUK7Y_VtrfzGWmDtmecqHa9CqsuqKGIIATKZRn0sQq_4SUahjkEUvppoTt6NRR8jIxNxcVoTQ_Qx6r9n3HOkBe6fgN98wilLXPGctXhVXCVR2KaTutBMcsnftRq_Mdu0sHW'
      },
    );
  }
}

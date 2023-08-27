import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

listenNotification({Future<dynamic> Function(String?)? onSelectNotification}) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) => firebaseMessageListener(message, onSelectNotification: onSelectNotification));
}

firebaseMessageListener(RemoteMessage message, {Future<dynamic> Function(String?)? onSelectNotification}) async {
  RemoteNotification? notification = message.notification;

  flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onSelectNotification: onSelectNotification);
  int id;
  String title, body;

  if (notification != null) {
    id = message.notification.hashCode;
    title = notification.title ?? "";
    body = notification.body ?? "";
  } else {
    title = message.data['title'] ?? "";
    body = message.data['body'] ?? "";
    id = Random().nextInt(1000000000);
  }

  flutterLocalNotificationsPlugin.show(
    id,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channel.description,
      ),
    ),
    payload: jsonEncode(message.data),
  );
}

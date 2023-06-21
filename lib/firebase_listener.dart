import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:siraf3/settings.dart';

import 'main.dart';

listenNotification() async {
  if (await (Settings().showNotification())) {
    FirebaseMessaging.onMessage.listen(firebaseMessageListener);
  }
}

firebaseMessageListener(RemoteMessage message) async {
  if (message.data.isEmpty) return;

  RemoteNotification? notification = message.notification;

  flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onSelectNotification: (_) async {});
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
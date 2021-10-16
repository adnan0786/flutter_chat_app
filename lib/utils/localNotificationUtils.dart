import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/chatModel.dart';
import 'package:flutter_chat_app/models/notificationModel.dart';
import 'package:flutter_chat_app/screens/messageScreen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationUtils {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? data) async {
      if (data != null) {
        NotificationModel notificationModel =
            NotificationModel.fromJson(jsonDecode(data));
        Get.to(MessageScreen(), arguments: [
          ChatModel(notificationModel.chatId, "", Timestamp.now(), List.empty(),
              image: notificationModel.image, name: notificationModel.name),
          notificationModel.userId
        ]);
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "flutterchat",
        "flutterchat channel",
        channelDescription: "this is our channel",
        importance: Importance.max,
        priority: Priority.high,
      ));

      NotificationModel notificationModel =
          NotificationModel.fromJson(message.data);
      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: notificationModel.toJsonString(),
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> _showBigPictureNotificationURL(RemoteMessage message) async {
    final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl('https://via.placeholder.com/48x48'));
    final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl('https://via.placeholder.com/400x800'));

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(bigPicture,
            largeIcon: largeIcon,
            contentTitle: '<b>Texting big picture</b>',
            htmlFormatContentTitle: true,
            summaryText: 'summary',
            htmlFormatSummaryText: false);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'big text channel id', 'big text channel name',
            channelDescription: 'big text channel description',
            styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationsPlugin.show(message.hashCode, 'big text title',
        'silent body', platformChannelSpecifics);
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }
}


import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:forwa_app/screens/base_controller/app_notification_controller.dart';
import 'package:forwa_app/screens/base_controller/chat_controller.dart';
import 'package:get/get.dart';

const MESSAGE_TYPE_CHAT = 'chat';

class FirebaseMessagingService {

  final NotificationService _notificationService = Get.find();
  final ChatController _chatController = Get.find();
  final AppNotificationController _appNotificationController = Get.find();

  void init() {
    _setup();

    _handleForegroundMessage();
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  void _handleForegroundMessage(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final RemoteNotification? notification = message.notification;
      if (notification != null) {
        _notificationService.showNotification(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
        );
      }

      final data = message.data;
      switch(data['type']){
        case MESSAGE_TYPE_CHAT:
          _chatController.unreadMessageCount.value++;
          break;
        case APP_NOTIFICATION_TYPE_PROCESSING:
          final noti = AppNotification.fromJson(jsonDecode(data['data']));
          _appNotificationController.increaseMyGiving(noti);
          break;
        case APP_NOTIFICATION_TYPE_SELECTED:
          final noti = AppNotification.fromJson(jsonDecode(data['data']));
          _appNotificationController.increaseMyReceiving(noti);
          break;
        default:
          break;
      }
    });
  }

  Future _setup() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    // /// Update the iOS foreground notification presentation options to allow
    // /// heads up notifications.
    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      debugPrint(message.data.toString());
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('An initial message event was published!');
      }
    });
  }
}

Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
  // message.data
}


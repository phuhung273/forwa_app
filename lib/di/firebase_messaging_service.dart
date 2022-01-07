
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:forwa_app/datasource/local/persistent_local_storage.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:forwa_app/screens/base_controller/app_notification_controller.dart';
import 'package:forwa_app/screens/base_controller/chat_controller.dart';
import 'package:forwa_app/screens/my_givings/my_giving_screen_controller.dart';
import 'package:forwa_app/screens/my_receivings/my_receivings_screen_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const MESSAGE_TYPE_CHAT = 'chat';

class FirebaseMessagingService {

  final NotificationService _notificationService = Get.find();
  final ChatController _chatController = Get.find();
  final AppNotificationController _appNotificationController = Get.find();
  final MyReceivingsScreenController _myReceivingsScreenController = Get.find();
  final MyGivingsScreenController _myGivingsScreenController = Get.find();

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
          _handleForegroundChatNotification(data);
          break;
        case APP_NOTIFICATION_TYPE_PROCESSING:
          _handleForegroundProcessingOrderNotification(data);
          break;
        case APP_NOTIFICATION_TYPE_SELECTED:
          _handleForegroundSelectedOrderNotification(data);
          break;
        default:
          break;
      }
    });
  }

  _handleForegroundChatNotification(Map<String, dynamic> data){
    _chatController.increase(1);
  }

  _handleForegroundProcessingOrderNotification(Map<String, dynamic> data){
    final noti = AppNotification.fromJson(jsonDecode(data['data']));
    print(data['order']);
    _appNotificationController.increaseMyGiving(noti);
    _myGivingsScreenController.increaseOrderOfProductId(noti.product.id!);
  }

  _handleForegroundSelectedOrderNotification(Map<String, dynamic> data){
    final noti = AppNotification.fromJson(jsonDecode(data['data']));
    _appNotificationController.increaseMyReceiving(noti);
    _myReceivingsScreenController.changeOrderToSelectedByProductId(noti.product.id!);
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

  final data = message.data;
  switch(data['type']){
    case MESSAGE_TYPE_CHAT:
      await handleBackgroundChatNotification(data);
      break;
    case APP_NOTIFICATION_TYPE_PROCESSING:
      await handleBackgroundProcessingOrderNotification(data);
      break;
    case APP_NOTIFICATION_TYPE_SELECTED:
      await handleBackgroundSelectedOrderNotification(data);
      break;
    default:
      break;
  }
}

Future handleBackgroundChatNotification(Map<String, dynamic> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int unreadCount = prefs.getInt(UNREAD_COUNT_KEY) ?? 0;
  final newCount = unreadCount + 1;
  return prefs.setInt(UNREAD_COUNT_KEY, newCount);
}

Future handleBackgroundProcessingOrderNotification(Map<String, dynamic> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? orderStringList = prefs.getStringList(BACKGROUND_PROCESSING_ORDER_LIST_KEY);
  if(orderStringList == null){
    orderStringList = [data['order']];
  } else {
    orderStringList.add(data['order']);
  }
  return prefs.setStringList(BACKGROUND_PROCESSING_ORDER_LIST_KEY, orderStringList);
}

Future handleBackgroundSelectedOrderNotification(Map<String, dynamic> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? orderStringList = prefs.getStringList(BACKGROUND_SELECTED_ORDER_LIST_KEY);
  if(orderStringList == null){
    orderStringList = [data['order']];
  } else {
    orderStringList.add(data['order']);
  }
  return prefs.setStringList(BACKGROUND_SELECTED_ORDER_LIST_KEY, orderStringList);
}



import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/local/persistent_local_storage.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:forwa_app/schema/chat/chat_room.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/base_controller/app_notification_controller.dart';
import 'package:forwa_app/screens/base_controller/chat_controller.dart';
import 'package:forwa_app/screens/base_controller/order_controller.dart';
import 'package:forwa_app/screens/choose_receiver/choose_receiver_screen_controller.dart';
import 'package:forwa_app/screens/message/message_screen_controller.dart';
import 'package:forwa_app/screens/my_receivings/my_receivings_screen_controller.dart';
import 'package:forwa_app/screens/order/order_screen_controller.dart';
import 'package:forwa_app/screens/product/product_screen_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const NOTIFICATION_TYPE_CHAT = 'chat';

class FirebaseMessagingService {

  final NotificationService _notificationService = Get.find();
  final ChatController _chatController = Get.find();
  final OrderController _orderController = Get.find();
  final AppNotificationController _appNotificationController = Get.find();
  final MyReceivingsScreenController _myReceivingsScreenController = Get.find();
  final LocalStorage _localStorage = Get.find();

  void init() {
    _setup();

    _handleForegroundMessage();
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  void _handleForegroundMessage(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final RemoteNotification? notification = message.notification;
      final data = message.data;

      if (notification != null) {
        _notificationService.showNotification(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          payload: jsonEncode(data)
        );
      }

      if(_localStorage.getUserID() != null){

        switch(data['type']){
          case NOTIFICATION_TYPE_CHAT:
            _handleForegroundChatNotification(data);
            break;
          case APP_NOTIFICATION_TYPE_PROCESSING:
            _handleForegroundProcessingOrderNotification(data);
            break;
          case APP_NOTIFICATION_TYPE_SELECTED:
            _handleForegroundSelectedOrderNotification(data);
            break;
          case APP_NOTIFICATION_TYPE_UPLOAD:
            _handleForegroundUploadNotification(data);
            break;
          default:
            break;
        }

      }
    });
  }

  _handleForegroundChatNotification(Map<String, dynamic> data){
    _chatController.increase(1);
  }

  _handleForegroundProcessingOrderNotification(Map<String, dynamic> data){
    final notification = AppNotification.fromJson(jsonDecode(data['data']));
    _appNotificationController.increaseMyGiving(notification);
    final order = Order.fromJson(jsonDecode(data['order']));
    _orderController.receiveProcessingOrder(order);
  }

  _handleForegroundSelectedOrderNotification(Map<String, dynamic> data){
    final notification = AppNotification.fromJson(jsonDecode(data['data']));
    final order = Order.fromJson(jsonDecode(data['order']));
    _appNotificationController.increaseMyReceiving(notification);
    _myReceivingsScreenController.changeOrderToSelected(order);
    final room = ChatRoom.fromJson(jsonDecode(data['room']));
    _chatController.addRoom(room);
  }

  _handleForegroundUploadNotification(Map<String, dynamic> data){
    final notification = AppNotification.fromJson(jsonDecode(data['data']));
    _appNotificationController.increaseMyNotification(notification);
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
      final data = message.data;
      switch(data['type']){
        case NOTIFICATION_TYPE_CHAT:
          MessageScreenController.openOrReloadScreenOnNotificationClick(data['room']);
          break;

        case APP_NOTIFICATION_TYPE_PROCESSING:
          final notification = AppNotification.fromJson(jsonDecode(data['data']));
          final order = Order.fromJson(jsonDecode(data['order']));
          ChooseReceiverScreenController.openOrReloadScreenOnNotificationClick(notification.product.id!, order.id);
          break;

        case APP_NOTIFICATION_TYPE_SELECTED:
          final notification = AppNotification.fromJson(jsonDecode(data['data']));
          final order = Order.fromJson(jsonDecode(data['order']));
          OrderScreenController.openOrReloadScreenOnNotificationClick(notification.product.id!, order.id);
          break;

        case APP_NOTIFICATION_TYPE_UPLOAD:
          final notification = AppNotification.fromJson(jsonDecode(data['data']));
          ProductScreenController.openOrReloadScreenOnNotificationClick(notification.product.id!);
          break;

        default:
          break;
      }
    });
  }
}


Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  final data = message.data;
  switch(data['type']){
    case NOTIFICATION_TYPE_CHAT:
      await handleBackgroundChatNotification(data);
      break;
    case APP_NOTIFICATION_TYPE_PROCESSING:
      await handleBackgroundNotification(data);
      await handleBackgroundProcessingOrderNotification(data);
      break;
    case APP_NOTIFICATION_TYPE_SELECTED:
      await handleBackgroundNotification(data);
      await handleBackgroundSelectedOrderNotification(data);
      break;
    case APP_NOTIFICATION_TYPE_UPLOAD:
      await handleBackgroundNotification(data);
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

  List<String>? roomStringList = prefs.getStringList(BACKGROUND_SELECTED_ROOM_LIST_KEY);
  if(roomStringList == null){
    roomStringList = [data['room']];
  } else {
    roomStringList.add(data['room']);
  }

  final resultRoom = await prefs.setStringList(BACKGROUND_SELECTED_ROOM_LIST_KEY, roomStringList);
  final resultOrder = await prefs.setStringList(BACKGROUND_SELECTED_ORDER_LIST_KEY, orderStringList);
  return resultRoom && resultOrder;
}

Future handleBackgroundNotification(Map<String, dynamic> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? uploadStringList = prefs.getStringList(BACKGROUND_NOTIFICATION_LIST_KEY);
  if(uploadStringList == null){
    uploadStringList = [data['data']];
  } else {
    uploadStringList.add(data['data']);
  }
  return prefs.setStringList(BACKGROUND_NOTIFICATION_LIST_KEY, uploadStringList);
}


import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/di/firebase_messaging_service.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/choose_receiver/choose_receiver_screen_controller.dart';
import 'package:forwa_app/screens/message/message_screen_controller.dart';
import 'package:forwa_app/screens/order/order_screen_controller.dart';
import 'package:forwa_app/screens/product/product_screen_controller.dart';
import 'package:get/get.dart';


const NOTIFICATION_START_TRUE = 'yes';
const notificationStartParam = 'notification_start';
const NOTIFICATION_START_FROM_TERMINATED_TRUE = 'yes';
const notificationStartFromTerminatedParam = 'notification_start_from_terminated';

class NotificationService {

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = Get.find();

  final _platformChannelSpecifics = const NotificationDetails(
    android: AndroidNotificationDetails(
      'forwa_channel_id4',
      'forwa_channel_name4',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Ticker',
      icon: '@drawable/launcher_icon',
      largeIcon: DrawableResourceAndroidBitmap('launcher_icon'),
      color: secondaryColorDark,
    ),
    iOS: IOSNotificationDetails(),
  );

  late AndroidNotificationChannel channel;

  Future init() async {

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('launcher_icon');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          final data = jsonDecode(payload);
          _handleForegroundNotificationClick(data);
        }
      }
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    channel = AndroidNotificationChannel(
      _platformChannelSpecifics.android!.channelId,
      _platformChannelSpecifics.android!.channelName,
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _platformChannelSpecifics,
      payload: payload,
    );
  }

  void _handleForegroundNotificationClick(Map<String, dynamic> data){

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
  }
}


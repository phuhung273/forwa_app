import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:forwa_app/constants.dart';
import 'package:get/get.dart';

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

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
}

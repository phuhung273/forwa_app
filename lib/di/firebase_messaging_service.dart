import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/schema/auth/firebase_token.dart';
import 'package:forwa_app/schema/auth/save_firebase_token_request.dart';
import 'package:get/get.dart';

class FirebaseMessagingService {

  final NotificationService _notificationService = Get.find();

  final AuthRepo _authRepo = Get.find();

  final LocalStorage _localStorage = Get.find();

  void init() {
    _setup();
    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(_saveToken);

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
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('An initial message event was published!');
      }
    });
  }


  Future _saveToken(String token) async {
    final deviceName = _localStorage.getDeviceName();

    if(deviceName == null) return;
    final request = SaveFirebaseTokenRequest(
      token: FirebaseToken(
        value: token,
        deviceName: deviceName
      )
    );

    final response = await _authRepo.saveFirebaseToken(request);
    if(!response.isSuccess || response.data == null){
      return;
    }

    _localStorage.saveFirebaseToken(response.data!);
  }
}

Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}
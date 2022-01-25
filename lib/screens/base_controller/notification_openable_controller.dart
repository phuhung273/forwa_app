
import 'dart:async';

import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/base_controller/navigation_controller.dart';
import 'package:get/get.dart';

abstract class NotificationOpenableController extends BaseController {

  String get screenName;

  final NavigationController navigationController = Get.find();

  bool isNotificationStart = false;

  StreamSubscription? _navigationSubscription;

  @override
  void onInit() {
    super.onInit();

    if(Get.parameters[notificationStartParam] == NOTIFICATION_START_TRUE){
      isNotificationStart = true;
    }

    _navigationSubscription = navigationController.directReloadStream.listen((event) {
      if(event[RELOAD_KEY_SCREEN_NAME] == screenName){
        onNotificationReload(event[RELOAD_KEY_PARAMETERS]);
      }
    });
  }

  onNotificationReload(Map parameters);

  @override
  void onClose(){
    _navigationSubscription?.cancel();
    super.onClose();
  }
}
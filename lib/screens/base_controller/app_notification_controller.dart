import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/local/persistent_local_storage.dart';
import 'package:forwa_app/datasource/repository/app_notification_repo.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:get/get.dart';

class AppNotificationController extends GetxController
    with WidgetsBindingObserver {

  final AppNotificationRepo _appNotificationRepo = Get.find();

  final LocalStorage _localStorage = Get.find();

  final PersistentLocalStorage _persistentLocalStorage = Get.find();

  final notifications = List<AppNotification>.empty().obs;
  int? _userId;

  final myGivingCount = 0.obs;
  final myReceivingCount = 0.obs;
  final notificationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
    _userId = _localStorage.getUserID();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.paused){
      // print('Im dead');
    }

    final lastState = WidgetsBinding.instance?.lifecycleState;
    if(lastState == AppLifecycleState.resumed){
      // print('Im alive');
      final backgroundNotificationList = await _persistentLocalStorage.getBackgroundUploadList();
      if(backgroundNotificationList != null && backgroundNotificationList.isNotEmpty){
        for (final element in backgroundNotificationList) {
          final notification = AppNotification.fromJson(jsonDecode(element));
          increaseMyNotification(notification);
        }
        _persistentLocalStorage.eraseBackgroundUploadList();
      }
    }
  }

  @override
  void onReady() {
    super.onReady();

    main();
  }

  Future main() async {
    if(_userId == null) return;

    final response = await _appNotificationRepo.getMyNoti();

    if(!response.isSuccess || response.data == null){
      return;
    }

    final data = response.data!;
    notifications.assignAll(data);

    myGivingCount.value = data.fold(0, (previousValue, element) =>
      element.status != AppNotificationStatus.CLICKED && element.type == AppNotificationType.PROCESSING
        ? previousValue + 1
        : previousValue
    );

    myReceivingCount.value = data.fold(0, (previousValue, element) =>
      element.status != AppNotificationStatus.CLICKED && element.type == AppNotificationType.SELECTED
          ? previousValue + 1
          : previousValue
    );

    notificationCount.value = data.fold(0, (previousValue, element) =>
      element.status == AppNotificationStatus.UNREAD
          ? previousValue + 1
          : previousValue
    );
  }

  void readMyGiving(){
    myGivingCount.value = 0;
  }

  void readMyReceiving(){
    myReceivingCount.value = 0;
  }

  void readMyNotification(){
    notificationCount.value = 0;
  }

  void increaseMyGiving(AppNotification notification){
    myGivingCount.value++;
    notificationCount.value++;
    insertNotification(notification);
  }

  void increaseMyReceiving(AppNotification notification){
    myReceivingCount.value++;
    notificationCount.value++;
    insertNotification(notification);
  }

  void increaseMyNotification(AppNotification notification){
    notificationCount.value++;
    insertNotification(notification);
  }

  void insertNotification(AppNotification notification){
    notifications.insert(0, notification);
  }

  void assignAll(List<AppNotification> notifications){
    notifications.assignAll(notifications);
  }

  @override
  void onClose(){
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
  }
}
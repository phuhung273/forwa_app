import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/local/persistent_local_storage.dart';
import 'package:forwa_app/datasource/repository/app_notification_repo.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/base_controller/order_controller.dart';
import 'package:get/get.dart';

class AppNotificationController extends GetxController
    with WidgetsBindingObserver {

  final AppNotificationRepo _appNotificationRepo = Get.find();

  final LocalStorage _localStorage = Get.find();

  final PersistentLocalStorage _persistentLocalStorage = Get.find();

  final OrderController _orderController = Get.find();

  final notifications = List<AppNotification>.empty().obs;
  int? _userId;

  final myGivingCount = 0.obs;
  final myReceivingCount = 0.obs;
  final notificationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
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
      _handleOnBackgroundOpenNotificationList();
      _handleOnBackgroundOpenProcessingOrderList();
      _handleOnBackgroundOpenSelectedOrderList();
    }
  }

  @override
  void onReady() {
    super.onReady();

    main();
  }

  Future main() async {
    _userId = _localStorage.getUserID();
    if(_userId == null) return;

    final response = await _appNotificationRepo.getMyNoti();

    if(!response.isSuccess || response.data == null){
      return;
    }

    final data = response.data!;
    notifications.assignAll(data);

    myGivingCount.value = data.fold(0, (previousValue, element) =>
      element.status != AppNotificationStatus.clicked && element.type == AppNotificationType.processing
        ? previousValue + 1
        : previousValue
    );

    myReceivingCount.value = data.fold(0, (previousValue, element) =>
      element.status != AppNotificationStatus.clicked && element.type == AppNotificationType.selected
          ? previousValue + 1
          : previousValue
    );

    notificationCount.value = data.fold(0, (previousValue, element) =>
      element.status == AppNotificationStatus.unread
          ? previousValue + 1
          : previousValue
    );
  }

  void _handleOnBackgroundOpenNotificationList() async {
    final backgroundNotificationList = await _persistentLocalStorage.getBackgroundNotificationList();

    if(_localStorage.getUserID() != null
        && backgroundNotificationList != null
        && backgroundNotificationList.isNotEmpty
    ){
      for (final element in backgroundNotificationList) {
        final notification = AppNotification.fromJson(jsonDecode(element));

        switch(notification.type){
          case AppNotificationType.processing:
            increaseMyGiving(notification);
            break;
          case AppNotificationType.selected:
            increaseMyReceiving(notification);
            break;
          case AppNotificationType.upload:
            increaseMyNotification(notification);
            break;
          default:
            break;
        }
      }
    }
    _persistentLocalStorage.eraseBackgroundNotificationList();
  }

  void _handleOnBackgroundOpenProcessingOrderList() async {
    final backgroundNotificationList = await _persistentLocalStorage.getBackgroundProcessingOrderList();
    if(_localStorage.getUserID() != null
        && backgroundNotificationList != null
        && backgroundNotificationList.isNotEmpty
    ){
      for (final element in backgroundNotificationList) {
        final order = Order.fromJson(jsonDecode(element));
        _orderController.receiveProcessingOrder(order);
      }
    }
    _persistentLocalStorage.eraseBackgroundProcessingOrderList();
  }

  void _handleOnBackgroundOpenSelectedOrderList() async {
    final backgroundNotificationList = await _persistentLocalStorage.getBackgroundSelectedOrderList();
    if(_localStorage.getUserID() != null
        && backgroundNotificationList != null
        && backgroundNotificationList.isNotEmpty
    ){
      for (final element in backgroundNotificationList) {
        final order = Order.fromJson(jsonDecode(element));
        _orderController.receiveSelectedOrder(order);
      }
    }
    _persistentLocalStorage.eraseBackgroundProcessingOrderList();
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

  void assignAll(List<AppNotification> items){
    notifications.assignAll(items);
  }

  void clear(){
    notifications.clear();
    notificationCount.value = 0;
    myReceivingCount.value = 0;
    myGivingCount.value = 0;
  }

  @override
  void onClose(){
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
  }
}
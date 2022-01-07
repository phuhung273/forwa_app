import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/local/persistent_local_storage.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/di/location_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/base_controller/authorized_refreshable_controller.dart';
import 'package:forwa_app/screens/take_success/take_success_screen_controller.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MyReceivingsScreenController extends AuthorizedRefreshableController
    with WidgetsBindingObserver {

  bool _initialized = false;

  final LocalStorage _localStorage = Get.find();

  final OrderRepo _orderRepo = Get.find();

  final LocationService _locationService = Get.find();

  final Distance distance = Get.find();

  final PersistentLocalStorage _persistentLocalStorage = Get.find();

  int? _customerId;

  final orders = List<Order>.empty().obs;

  LocationData? here;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
    _customerId = _localStorage.getUserID();
  }

  void changeTab() async {
    if(!_initialized){
      final result = await super.onReady();
      if(result){
        _initialized = true;
      }
    }
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
      final backgroundNotificationList = await _persistentLocalStorage.getBackgroundSelectedOrderList();
      if(backgroundNotificationList != null && backgroundNotificationList.isNotEmpty && _initialized){
        for (final element in backgroundNotificationList) {
          final order = Order.fromJson(jsonDecode(element));
          changeOrderToSelectedByProductId(order.productId);
        }
        _persistentLocalStorage.eraseBackgroundProcessingOrderList();
      }
    }
  }

  @override
  Future<bool> onReady() async {
    if(!isAuthorized()){
      return false;
    }

    _locationService.here().then((value) => here = value);
    return true;
  }

  @override
  bool isAuthorized() {
    _customerId = _localStorage.getUserID();
    return _customerId != null;
  }

  @override
  Future main() async {
    final response = await _orderRepo.getMyOrders();
    if(!response.isSuccess || response.data == null){
      return;
    }

    orders.assignAll(response.data ?? []);
  }

  void changeOrderToSelectedByProductId(int id){
    if(_initialized){
      final index = orders.indexWhere((element) => element.productId == id);
      if(index > -1){
        orders[index].status = EnumToString.convertToString(OrderStatus.SELECTED).toLowerCase();
        orders.refresh();
      }
    }
  }

  Future takeSuccess(int index) async {
    final order = orders[index];
    Get.toNamed(
      ROUTE_TAKE_SUCCESS,
      parameters: {
        customerNameParam: order.sellerName!,
        toIdParam: order.product!.user!.id.toString(),
        orderIdParam: order.id.toString(),
      }
    );
  }

  void setSuccessReviewId(int orderId, int reviewId){
    final index = orders.indexWhere((element) => element.id == orderId);

    if(index > -1){
      orders[index].buyerReviewId = reviewId;
      orders.refresh();
    }
  }

  void insertOrder(Order order){
    if(_initialized){
      orders.insert(0, order);
      orders.refresh();
    }
  }

  @override
  void dispose(){
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
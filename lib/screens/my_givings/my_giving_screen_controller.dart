import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/local/persistent_local_storage.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/screens/base_controller/authorized_refreshable_controller.dart';
import 'package:get/get.dart';

class MyGivingsScreenController extends AuthorizedRefreshableController
    with WidgetsBindingObserver {

  bool _initialized = false;

  final ProductRepo _productRepo = Get.find();

  final LocalStorage _localStorage = Get.find();

  final PersistentLocalStorage _persistentLocalStorage = Get.find();

  final products = List<Product>.empty().obs;
  int? _userId;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
    _userId = _localStorage.getUserID();
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
      final backgroundNotificationList = await _persistentLocalStorage.getBackgroundProcessingOrderList();
      if(backgroundNotificationList != null && backgroundNotificationList.isNotEmpty && _initialized){
        for (final element in backgroundNotificationList) {
          final order = Order.fromJson(jsonDecode(element));
          increaseOrderOfProductId(order.productId);
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
    return true;
  }

  @override
  Future main() async {
    final response = await _productRepo.getMyProducts();

    if(!response.isSuccess || response.data == null){
      return;
    }

    products.assignAll(response.data!.items);
  }

  void increaseOrderOfProductId(int productId){
    if(_initialized){
      final index = products.indexWhere((element) => element.id == productId);
      if(index > -1) {
        products[index].orderCount = products[index].orderCount == null
            ? 1
            : products[index].orderCount! + 1;
        products.refresh();
      }
    }
  }

  @override
  bool isAuthorized() {
    _userId = _localStorage.getUserID();
    return _userId != null;
  }

  @override
  void dispose(){
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
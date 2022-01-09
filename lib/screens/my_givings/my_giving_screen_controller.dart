import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/local/persistent_local_storage.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/mixins/lazy_load.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/schema/product/lazy_giving_request.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/screens/base_controller/authorized_refreshable_controller.dart';
import 'package:get/get.dart';

class MyGivingsScreenController extends AuthorizedRefreshableController
    with WidgetsBindingObserver, LazyLoad  {

  bool _initialized = false;

  final ProductRepo _productRepo = Get.find();

  final LocalStorage _localStorage = Get.find();

  final PersistentLocalStorage _persistentLocalStorage = Get.find();

  final products = List<Product>.empty().obs;
  int? _userId;

  @override
  int get listLength => products.length;

  late int _lowProductId;

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

    initLazyLoad();
    return true;
  }

  @override
  Future main() async {
    final response = await _productRepo.getMyProducts();

    if(!response.isSuccess || response.data == null){
      return;
    }

    final items = response.data!.items;
    products.assignAll(items);

    if(items.length < 10){
      stopLazyLoad();
    } else {
      _calculateEdgeId();
      resetLazyLoad();
    }
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

  void changeProductIdToSuccess(int productId){
    if(_initialized){
      final index = products.indexWhere((element) => element.id == productId);
      if(index > -1) {
        products[index].statusString = EnumToString.convertToString(ProductStatus.FINISH).toLowerCase();
        products.refresh();
      }
    }
  }

  @override
  Future onLazyLoad() async {
    final request = LazyGivingRequest(
        lowProductId: _lowProductId
    );

    final response = await _productRepo.lazyLoadMyGiving(request);

    if(!response.isSuccess || response.data == null){
      return;
    }

    final newItems = response.data!;
    if(newItems.isEmpty){
      stopLazyLoad();
      return;
    }

    products.addAll(newItems);
    _calculateEdgeId();
  }

  void _calculateEdgeId(){
    _lowProductId = products.first.id!;
    for (var product in products) {
      if(product.id! < _lowProductId){
        _lowProductId = product.id!;
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

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/mixins/lazy_load.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/product/lazy_giving_request.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/screens/base_controller/main_tab_controller.dart';
import 'package:forwa_app/screens/base_controller/order_controller.dart';
import 'package:forwa_app/screens/base_controller/product_success_controller.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:get/get.dart';

class MyGivingsScreenController extends MainTabController
    with LazyLoad  {

  static const actionUpdate = 'update';
  static const actionDelete = 'delete';

  final ProductRepo _productRepo = Get.find();

  final LocalStorage _localStorage = Get.find();

  final OrderController _orderController = Get.find();
  final ProductSuccessController _productSuccessController = Get.find();

  final products = List<Product>.empty().obs;
  int? _userId;

  @override
  int get pageIndex => MY_GIVINGS_SCREEN_INDEX;

  @override
  int get listLength => products.length;

  late int _lowId;

  @override
  void onInit(){
    super.onInit();

    _orderController.processingOrderStream.listen((event) {
      if(loggedIn){
        increaseOrderOfProductId(event.productId);
      }
    });

    _productSuccessController.productSuccessStream.listen((event) {
      if(loggedIn){
        changeProductIdToSuccess(event);
      }
    });
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
    _userId = _localStorage.getUserID();
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
    if(loggedIn){
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
    if(loggedIn){
      final index = products.indexWhere((element) => element.id == productId);
      if(index > -1) {
        products[index].statusString = EnumToString.convertToString(ProductStatus.finish);
        products.refresh();
      }
    }
  }

  @override
  Future onLazyLoad() async {
    final request = LazyGivingRequest(
        lowId: _lowId
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
    _lowId = products.first.id!;
    for (var item in products) {
      if(item.id! < _lowId){
        _lowId = item.id!;
      }
    }
  }

  Future showActionModal(int id) async {
    final context = Get.context;
    if(context == null) return;

    final result = await showModalActionSheet<String>(
      context: context,
      style: AdaptiveStyle.material,
      actions: [
        const SheetAction(
          icon: Icons.edit,
          label: 'Chỉnh sửa món đồ',
          key: actionUpdate,
        ),
        const SheetAction(
          icon: Icons.cancel,
          label: 'Xóa món đồ',
          key: actionDelete,
        ),
      ],
    );

    switch(result){
      case actionUpdate:
        Get.toNamed(ROUTE_PRODUCT_EDIT, arguments: id);
        break;
      case actionDelete:
        break;
      default:
        break;
    }
  }

  @override
  void cleanData(){
    products.clear();
  }

  @override
  bool isAuthorized() {
    _userId = _localStorage.getUserID();
    return _userId != null;
  }
}
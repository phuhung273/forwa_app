import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/persistent_local_storage.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart' hide errorCodeMap;
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/give_success/give_success_screen_controller.dart';
import 'package:forwa_app/screens/my_givings/my_giving_screen_controller.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ChooseReceiverScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChooseReceiverScreenController());
  }
}

const productIdParamChooseReceiver = 'product_id';


class ChooseReceiverScreenController extends BaseController
    with WidgetsBindingObserver {

  late MyGivingsScreenController _myGivingsScreenController;

  final ProductRepo _productRepo = Get.find();

  final OrderRepo _orderRepo = Get.find();
  final PersistentLocalStorage _persistentLocalStorage = Get.find();

  bool isNotificationStart = false;
  int? _productId;
  final finish = true.obs;

  final orders = List<Order>.empty().obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
    _productId = int.tryParse(Get.parameters[productIdParamChooseReceiver]!);
    if(Get.parameters[notificationStartParam] == NOTIFICATION_START_TRUE){
      isNotificationStart = true;
    } else {
      _myGivingsScreenController = Get.find();
    }
  }

  @override
  void onReady() async {
    super.onReady();

    showLoadingDialog();
    final response = await _orderRepo.getOrdersOfProductId(_productId!);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      return;
    }

    orders.assignAll(response.data?.orders ?? []);
    finish.value = response.data?.product.status == ProductStatus.FINISH;
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
      if(backgroundNotificationList != null && backgroundNotificationList.isNotEmpty){
        for (final element in backgroundNotificationList) {
          final order = Order.fromJson(jsonDecode(element));
          orders.add(order);
        }
        _persistentLocalStorage.eraseBackgroundProcessingOrderList();
      }
    }
  }

  Future pickReceiver(int orderId) async {
    if(_productId == null) {
      return;
    }

    final context = Get.context;
    if(context == null || _productId == null) return;

    final theme = Theme.of(context);

    final result = await Alert(
      context: context,
      type: AlertType.success,
      title: 'Xác nhận',
      desc: 'Chọn người này? Sau khi chọn, 2 bạn sẽ được chat với nhau',
      style: AlertStyle(
        descStyle: theme.textTheme.bodyText1!,
      ),
      buttons: [
        DialogButton(
          child: const Text(
            'Hủy',
          ),
          onPressed: () => Get.back(),
          color: Colors.grey[300],
        ),
        DialogButton(
          child: Text(
            'Xác nhận',
            style: theme.textTheme.subtitle1?.copyWith(
              color: Colors.white,
            ),
          ),
          onPressed: () => Get.back(result: true),
          color: theme.colorScheme.secondary,
        )
      ],
    ).show();

    if(result != true) return;

    showLoadingDialog();
    final response = await _orderRepo.selectOrder(orderId);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      return;
    }

    final index = orders.indexWhere((element) => element.id == orderId);
    orders[index].status = EnumToString.convertToString(OrderStatus.SELECTED).toLowerCase();
    orders.refresh();
  }

  Future orderToSuccess(int index) async {
    final order = orders[index];
    Get.toNamed(
      ROUTE_GIVE_SUCCESS,
      parameters: {
        customerNameParam: order.user!.name,
        toIdParam: order.userId.toString(),
        orderIdParam: order.id.toString(),
      }
    );
  }

  Future productToSuccess() async {
    final context = Get.context;
    if(context == null || _productId == null) return;

    final theme = Theme.of(context);

    final result = await Alert(
      context: context,
      type: AlertType.success,
      title: 'Hoàn tất',
      desc: 'Ngưng nhận thêm người cho món đồ này?',
      style: AlertStyle(
        descStyle: theme.textTheme.bodyText1!,
      ),
      buttons: [
        DialogButton(
          child: const Text(
            'Hủy',
          ),
          onPressed: () => Get.back(),
          color: Colors.grey[300],
        ),
        DialogButton(
          child: Text(
            'Xác nhận',
            style: theme.textTheme.subtitle1?.copyWith(
              color: Colors.white,
            ),
          ),
          onPressed: () => Get.back(result: true),
          color: theme.colorScheme.secondary,
        )
      ],
    ).show();

    if(result != true) return;

    showLoadingDialog();
    final response = await _productRepo.finishProduct(_productId!);

    hideDialog();
    if(!response.isSuccess || response.data == null){
      final message = errorCodeMap[response.statusCode] ?? 'Lỗi không xác định';
      showErrorDialog(message: message);
      return;
    }

    await showSuccessDialog(message: 'Thành công');

    if(!isNotificationStart){
      _myGivingsScreenController.changeProductIdToSuccess(response.data!.id!);
    }

    finish.value = true;
  }

  void setSuccessReviewId(int orderId, int reviewId){
    final index = orders.indexWhere((element) => element.id == orderId);

    if(index > -1){
      orders[index].sellerReviewId = reviewId;
      orders.refresh();
    }
  }

  @override
  void onClose(){
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
  }
}
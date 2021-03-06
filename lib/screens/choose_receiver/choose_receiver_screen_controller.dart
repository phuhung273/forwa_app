import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart' hide errorCodeMap;
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/screens/base_controller/chat_controller.dart';
import 'package:forwa_app/screens/base_controller/navigation_controller.dart';
import 'package:forwa_app/screens/base_controller/notification_openable_controller.dart';
import 'package:forwa_app/screens/base_controller/order_controller.dart';
import 'package:forwa_app/screens/base_controller/product_controller.dart';
import 'package:forwa_app/screens/give_success/give_success_screen_controller.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ChooseReceiverScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChooseReceiverScreenController());
  }
}

const productIdParamChooseReceiver = 'product_id';


class ChooseReceiverScreenController extends NotificationOpenableController{

  @override
  String get screenName => ROUTE_CHOOSE_RECEIVER;

  final ProductRepo _productRepo = Get.find();
  final OrderRepo _orderRepo = Get.find();
  final ChatController _chatController = Get.find();
  final ProductController _productController = Get.find();
  final OrderController _orderController = Get.find();

  int? _productId;
  final finish = true.obs;

  final orders = List<Order>.empty().obs;

  StreamSubscription? _processingOrderStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    _productId = int.tryParse(Get.parameters[productIdParamChooseReceiver]!);

    _processingOrderStreamSubscription = _orderController.processingOrderStream.listen((event) {
      if(event.productId == _productId){
        orders.add(event);
      }
    });
  }

  @override
  onNotificationReload(Map parameters) {
    _productId = parameters[productIdParamChooseReceiver];
    onReady();
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
    finish.value = response.data?.product.status == ProductStatus.finish;
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
      title: 'X??c nh???n',
      desc: 'Ch???n ng?????i n??y? Sau khi ch???n, 2 b???n s??? ???????c chat v???i nhau',
      style: AlertStyle(
        descStyle: theme.textTheme.bodyText1!,
      ),
      buttons: [
        DialogButton(
          child: const Text(
            'H???y',
          ),
          onPressed: () => Get.back(),
          color: Colors.grey[300],
        ),
        DialogButton(
          child: Text(
            'X??c nh???n',
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

    _chatController.addRoom(response.data!);
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
      title: 'Ho??n t???t',
      desc: 'Ng??ng nh???n th??m ng?????i cho m??n ????? n??y?',
      style: AlertStyle(
        descStyle: theme.textTheme.bodyText1!,
      ),
      buttons: [
        DialogButton(
          child: const Text(
            'H???y',
          ),
          onPressed: () => Get.back(),
          color: Colors.grey[300],
        ),
        DialogButton(
          child: Text(
            'X??c nh???n',
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
      final message = errorCodeMap[response.statusCode] ?? 'L???i kh??ng x??c ?????nh';
      showErrorDialog(message: message);
      return;
    }

    await showSuccessDialog(message: 'Th??nh c??ng');

    _productController.updateToSuccess(response.data!.id!);

    finish.value = true;
  }

  void setSuccessReviewId(int orderId, int reviewId){
    final index = orders.indexWhere((element) => element.id == orderId);

    if(index > -1){
      orders[index].sellerReviewId = reviewId;
      orders.refresh();
    }
  }

  bool canFinish(){
    return orders.any((element) => element.statusType == OrderStatus.SELECTED);
  }

  static void openScreen(int productId){
    Get.toNamed(
      ROUTE_CHOOSE_RECEIVER,
      parameters: {
        productIdParamChooseReceiver: productId.toString(),
      }
    );

    final AnalyticService analyticService = Get.find();
    analyticService.logSelectProductItem(productId);
  }

  static void openOrReloadScreenOnNotificationClick(int productId, int orderId){
    if(getEndPoint(Get.currentRoute) == ROUTE_CHOOSE_RECEIVER){
      final NavigationController navigationController = Get.find();
      navigationController.resetScreen(ROUTE_CHOOSE_RECEIVER, {
        productIdParamChooseReceiver: productId
      });
    } else {
      Get.toNamed(
        ROUTE_CHOOSE_RECEIVER,
        parameters: {
          productIdParamChooseReceiver: productId.toString(),
        }
      );
    }

    final AnalyticService analyticService = Get.find();
    analyticService.logClickProcessingNotification(orderId, productId);
  }

  static void openScreenOnTerminatedNotificationClick(int productId, int orderId){
    Get.offAllNamed(
      ROUTE_CHOOSE_RECEIVER,
      parameters: {
        productIdParamChooseReceiver: productId.toString(),
        notificationStartParam: NOTIFICATION_START_TRUE,
      }
    );

    final AnalyticService analyticService = Get.find();
    analyticService.logClickProcessingNotification(orderId, productId);
  }

  @override
  void onClose(){
    _processingOrderStreamSubscription?.cancel();
    super.onClose();
  }
}
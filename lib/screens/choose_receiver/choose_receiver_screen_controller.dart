import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
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

const productIdParam = 'product_id';

class ChooseReceiverScreenController extends BaseController {

  final MyGivingsScreenController _myGivingsScreenController = Get.find();

  final ProductRepo _productRepo = Get.find();

  final OrderRepo _orderRepo = Get.find();

  int? _productId;
  final finish = true.obs;

  final orders = List<Order>.empty().obs;

  @override
  void onInit() {
    super.onInit();
    _productId = int.tryParse(Get.parameters[productIdParam]!);

    final product = _myGivingsScreenController.products.firstWhere((element) => element.id == _productId);
    orders.assignAll(product.orders ?? []);
    finish.value = product.status == ProductStatus.FINISH;
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
          child: Text(
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
    Get.back();
  }

  void setSuccessReviewId(int orderId, int reviewId){
    final index = orders.indexWhere((element) => element.id == orderId);

    if(index > -1){
      orders[index].sellerReviewId = reviewId;
      orders.refresh();
    }
  }
}
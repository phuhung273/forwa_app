import 'package:flutter/cupertino.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/create_order_request.dart';
import 'package:forwa_app/screens/my_receivings/my_receivings_screen_controller.dart';
import 'package:get/get.dart';

import '../base_controller/base_controller.dart';

const idParam = 'id';
const sellerNameParam = 'seller_name';

class TakeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TakeScreenController());
  }
}

class TakeScreenController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final OrderRepo _orderRepo = Get.find();

  late MyReceivingsScreenController _myReceivingsScreenController;

  final String _id = Get.parameters[idParam]!;
  final String sellerName = Get.parameters[sellerNameParam]!;

  final TextEditingController messageController = TextEditingController();

  int? _userId;
  bool isNotificationStart = false;

  @override
  void onInit(){
    super.onInit();

    _userId = _localStorage.getUserID();

    if(Get.parameters[notificationStartParam] == NOTIFICATION_START_TRUE){
      isNotificationStart = true;
    } else {
      _myReceivingsScreenController = Get.find();
    }
  }

  @override
  void onReady() {
    if(_userId == null) {
      return;
    }
    messageController.text = '';
  }

  Future createOrder() async{
    showLoadingDialog();
    final request = CreateOrderRequest(message: messageController.text, productId: int.tryParse(_id)!);
    final response = await _orderRepo.createOrder(request);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      final message = errorCodeMap[response.statusCode] ?? 'Lỗi không xác định';
      showErrorDialog(message: message);
      return;
    }

    await showSuccessDialog(message: 'Thành công. Mong bạn sẽ được chọn!');

    if(!isNotificationStart){
      _myReceivingsScreenController.insertOrder(response.data!);
      Get.until((route) => route.settings.name == ROUTE_MAIN);
    } else {
      Get.offAllNamed(ROUTE_MAIN);
    }

  }

  @override
  void onClose(){
    messageController.dispose();
    super.onClose();
  }
}
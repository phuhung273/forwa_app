import 'package:flutter/cupertino.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/create_order_request.dart';
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

  final String _id = Get.parameters[idParam]!;
  final String sellerName = Get.parameters[sellerNameParam]!;

  final TextEditingController messageController = TextEditingController();

  int? _userId;

  @override
  void onInit(){
    super.onInit();

    _userId = _localStorage.getUserID();
  }

  @override
  void onReady() {
    if(_userId == null) {
      // TODO: Show error popup
      Get.back();
    }
    messageController.text = '';
  }

  Future addToOrder() async{
    showLoadingDialog();
    final request = CreateOrderRequest(message: messageController.text, productId: int.tryParse(_id)!);
    final response = await _orderRepo.createOrder(request);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      // TODO: show error popup
      return;
    }

    // TODO: show success popup

    Get.offNamedUntil(ROUTE_MAIN, (route) => route.settings.name == ROUTE_MAIN);
  }
}
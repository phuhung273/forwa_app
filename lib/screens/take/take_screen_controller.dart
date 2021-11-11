import 'package:flutter/cupertino.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/cart_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:get/get.dart';

import '../base_controller/base_controller.dart';

const skuParam = 'sku';
const sellerNameParam = 'seller_name';

class TakeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TakeScreenController());
  }
}

class TakeScreenController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final CartRepo _cartRepo = Get.find();

  final String _sku = Get.parameters[skuParam]!;
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
    final response = await _cartRepo.addToOrder(_sku, messageController.text);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      // TODO: show error popup
      return;
    }

    // TODO: show success popup

    Get.offAndToNamed(ROUTE_MAIN);
  }
}
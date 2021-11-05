import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/base_controller.dart';
import 'package:get/get.dart';

class MyReceivingsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyReceivingsScreenController());
  }
}

class MyReceivingsScreenController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final OrderRepo _orderRepo = Get.find();

  int? _customerId;

  final orders = List<Order>.empty().obs;

  @override
  void onInit() {
    super.onInit();

    _customerId = _localStorage.getUserID();
  }

  @override
  Future onReady() async {
    super.onReady();

    if(_customerId == null) {
      showLoginDialog();
      return;
    }

    showLoadingDialog();
    final response = await _orderRepo.getOrdersOfCustomer(_customerId!);
    hideDialog();
    if(!response.isSuccess || response.data == null || response.data!.items == null){
      return;
    }

    orders.assignAll(response.data!.items!);
  }
}
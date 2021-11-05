import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/cart_repo.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/schema/cart/cart_customer.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/base_controller.dart';
import 'package:get/get.dart';

class ChooseReceiverScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChooseReceiverScreenController());
  }
}

class ChooseReceiverScreenController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final CartRepo _cartRepo = Get.find();

  final OrderRepo _orderRepo = Get.find();

  final _productId = Get.arguments;

  final customers = List<CartCustomer>.empty().obs;

  @override
  Future onReady() async {
    if(_productId == null) {
      return;
    }

    showLoadingDialog();
    final response = await _cartRepo.getCustomersOfProduct(_productId);
    hideDialog();
    if(!response.isSuccess || response.data == null || response.data!.customers == null){
      return;
    }

    customers.assignAll(response.data!.customers!);
  }

  Future pickReceiver(int orderId) async {
    final token = _localStorage.getAccessToken();
    _localStorage.removeAccessToken();

    showLoadingDialog();
    final response = await _orderRepo.createInvoice(orderId);
    hideDialog();

    if(token != null) {
      _localStorage.saveAccessToken(token);
    }

    if(!response.isSuccess || response.data == null){
      return;
    }

    final index = customers.indexWhere((element) => element.orderId == orderId);
    customers[index].orderStatus = EnumToString.convertToString(OrderStatus.PROCESSING).toLowerCase();
    customers.refresh();
  }
}
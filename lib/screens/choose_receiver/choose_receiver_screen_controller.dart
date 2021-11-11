import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/cart_repo.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/cart/cart_customer.dart';
import 'package:forwa_app/schema/order/create_invoice_request.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/give_success/give_success_screen_controller.dart';
import 'package:get/get.dart';

class ChooseReceiverScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChooseReceiverScreenController());
  }
}

const productIdParam = 'product_id';
const productNameParam = 'product_name';

class ChooseReceiverScreenController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final CartRepo _cartRepo = Get.find();

  final OrderRepo _orderRepo = Get.find();

  int? _productId;
  final _productName = Get.parameters[productNameParam];

  final customers = List<CartCustomer>.empty().obs;

  @override
  void onInit() {
    super.onInit();
    _productId = int.tryParse(Get.parameters[productIdParam]!);
}

  @override
  Future onReady() async {
    if(_productId == null || _productName == null) {
      return;
    }

    showLoadingDialog();
    final response = await _cartRepo.getCustomersOfProduct(_productId!);
    hideDialog();
    if(!response.isSuccess || response.data == null || response.data!.customers == null){
      return;
    }

    customers.assignAll(response.data!.customers!);
  }

  Future pickReceiver(int orderId) async {
    if(_productId == null || _productName == null) {
      return;
    }

    final token = _localStorage.getAccessToken();
    _localStorage.removeAccessToken();

    final request = CreateInvoiceRequest(productName: _productName!);
    showLoadingDialog();
    final response = await _orderRepo.createInvoice(orderId, request);
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

  Future shipSuccess(String customerName) async {
    Get.toNamed(
      ROUTE_GIVE_SUCCESS,
      parameters: {
        customerNameParam: customerName
      }
    );
  }
}
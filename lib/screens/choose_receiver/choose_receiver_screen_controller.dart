import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/give_success/give_success_screen_controller.dart';
import 'package:forwa_app/screens/my_givings/my_giving_screen_controller.dart';
import 'package:get/get.dart';

class ChooseReceiverScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChooseReceiverScreenController());
  }
}

const productIdParam = 'product_id';

class ChooseReceiverScreenController extends BaseController {

  final MyGivingsScreenController _myGivingsScreenController = Get.find();

  final OrderRepo _orderRepo = Get.find();

  int? _productId;

  final orders = List<Order>.empty().obs;

  @override
  void onInit() {
    super.onInit();
    _productId = int.tryParse(Get.parameters[productIdParam]!);

    final product = _myGivingsScreenController.products.firstWhere((element) => element.id == _productId);
    orders.assignAll(product.orders ?? []);
  }

  Future pickReceiver(int orderId) async {
    if(_productId == null) {
      return;
    }

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

  Future toSuccess(int index) async {
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
}
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/base_controller/authorized_refreshable_controller.dart';
import 'package:forwa_app/screens/take_success/take_success_screen_controller.dart';
import 'package:get/get.dart';

class MyReceivingsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyReceivingsScreenController());
  }
}

class MyReceivingsScreenController extends AuthorizedRefreshableController {

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
  bool isAuthorized() {
    _customerId = _localStorage.getUserID();
    return _customerId != null;
  }

  @override
  Future main() async {
    final response = await _orderRepo.getMyOrders();
    if(!response.isSuccess || response.data == null){
      return;
    }

    orders.assignAll(response.data!.items ?? []);
  }

  Future takeSuccess(int index) async {
    final order = orders[index];
    Get.toNamed(
      ROUTE_TAKE_SUCCESS,
      parameters: {
        customerNameParam: order.sellerName!,
        toIdParam: order.product!.user!.id.toString(),
        orderIdParam: order.id.toString(),
      }
    );
  }
}
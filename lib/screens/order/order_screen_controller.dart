
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/di/location_service.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/take_success/take_success_screen_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class OrderScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderScreenController());
  }
}

const productIdParamOrderScreen = 'product_id';

class OrderScreenController extends BaseController {

  final OrderRepo _orderRepo = Get.find();

  final LocationService _locationService = Get.find();

  bool isNotificationStart = false;
  int? _productId;

  final sellerName = ''.obs;
  final productImageUrl = ''.obs;
  final userImageUrl = ''.obs;
  final sellerId = 0.obs;
  final productName = ''.obs;
  final status = OrderStatus.PROCESSING.obs;
  final buyerReviewId = 0.obs;
  final orderId = 0.obs;
  final chatRoomId = ''.obs;

  Position? here;

  @override
  void onInit() {
    super.onInit();
    _productId = int.tryParse(Get.parameters[productIdParamOrderScreen]!);
    if(Get.parameters[notificationStartParam] == NOTIFICATION_START_TRUE){
      isNotificationStart = true;
    }
    _locationService.here().then((value) => here = value);
  }

  @override
  void onReady() async {
    super.onReady();

    showLoadingDialog();
    final response = await _orderRepo.getMyOrderByProductId(_productId!);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      return;
    }

    final order = response.data!;
    orderId.value = order.id;
    sellerName.value = order.product!.user!.name;
    sellerId.value = order.product!.user!.id!;
    userImageUrl.value = order.product?.user?.imageUrl ?? '';
    productImageUrl.value = order.firstImageUrl ?? '';
    productName.value = order.product!.name;
    buyerReviewId.value = order.buyerReviewId ?? 0;
    status.value = order.statusType ?? OrderStatus.PROCESSING;
    chatRoomId.value = order.chatRoomId ?? '';
  }

  Future takeSuccess() async {
    Get.toNamed(
        ROUTE_TAKE_SUCCESS,
        parameters: {
          customerNameParam: sellerName.value,
          toIdParam: sellerId.string,
          orderIdParam: orderId.string,
          notificationStartParam: isNotificationStart ? NOTIFICATION_START_TRUE : '',
          previousRouteParam: ROUTE_ORDER
        }
    );
  }

  void setReviewId(int id){
    buyerReviewId.value = id;
  }

  static void openScreen(int productId){
    Get.toNamed(
      ROUTE_ORDER,
      parameters: {
        productIdParamOrderScreen: productId.toString()
      }
    );
  }

  static void openScreenOnNotificationClick(int productId, int orderId){
    Get.toNamed(
      ROUTE_ORDER,
      parameters: {
        productIdParamOrderScreen: productId.toString(),
      }
    );

    final AnalyticService analyticService = Get.find();
    analyticService.logClickSelectedNotification(orderId, productId);
  }

  static void openScreenOnTerminatedNotificationClick(int productId, int orderId){
    Get.offAllNamed(
      ROUTE_ORDER,
      parameters: {
        productIdParamOrderScreen: productId.toString(),
        notificationStartParam: NOTIFICATION_START_TRUE,
      }
    );

    final AnalyticService analyticService = Get.find();
    analyticService.logClickSelectedNotification(orderId, productId);
  }
}
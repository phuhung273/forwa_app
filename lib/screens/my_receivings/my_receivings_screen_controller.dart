
import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/di/location_service.dart';
import 'package:forwa_app/mixins/lazy_load.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/lazy_receiving_request.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/base_controller/main_tab_controller.dart';
import 'package:forwa_app/screens/base_controller/order_controller.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:forwa_app/screens/take_success/take_success_screen_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MyReceivingsScreenController extends MainTabController
    with LazyLoad {

  final LocalStorage _localStorage = Get.find();

  final OrderRepo _orderRepo = Get.find();

  final LocationService _locationService = Get.find();

  final OrderController _orderController = Get.find();

  final Distance distance = Get.find();

  int? _userId;

  final orders = List<Order>.empty().obs;

  Position? here;

  @override
  int get pageIndex => MY_RECEIVINGS_SCREEN_INDEX;

  @override
  int get listLength => orders.length;

  late int _lowId;

  @override
  void onInit(){
    super.onInit();

    _orderController.selectedOrderStream.listen(changeOrderToSelected);
  }

  @override
  Future<bool> onReady() async {
    if(!isAuthorized()){
      return false;
    }

    initLazyLoad();
    _locationService.here().then((value) => here = value);
    return true;
  }

  @override
  bool isAuthorized() {
    _userId = _localStorage.getUserID();
    return _userId != null;
  }

  @override
  Future main() async {
    _userId = _localStorage.getUserID();

    final response = await _orderRepo.getMyOrders();
    if(!response.isSuccess || response.data == null){
      return;
    }

    final items = response.data!;

    orders.assignAll(items);

    if(items.length < 10){
      stopLazyLoad();
    } else {
      _calculateEdgeId();
      resetLazyLoad();
    }
  }

  void changeOrderToSelected(Order order){
    if(loggedIn){
      final index = orders.indexWhere((element) => element.productId == order.productId);
      if(index > -1){
        orders[index].status = EnumToString.convertToString(OrderStatus.SELECTED).toLowerCase();
        orders[index].chatRoomId = order.chatRoomId;
        orders.refresh();
      }
    }
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

  void setSuccessReviewId(int orderId, int reviewId){
    if(loggedIn){
      final index = orders.indexWhere((element) => element.id == orderId);

      if(index > -1){
        orders[index].buyerReviewId = reviewId;
        orders.refresh();
      }
    }
  }

  void insertOrder(Order order){
    if(loggedIn){
      orders.insert(0, order);
      orders.refresh();
    }
  }

  @override
  Future onLazyLoad() async {
    final request = LazyReceivingRequest(
        lowId: _lowId
    );

    final response = await _orderRepo.lazyLoadMyOrders(request);

    if(!response.isSuccess || response.data == null){
      return;
    }

    final newItems = response.data!;
    if(newItems.isEmpty){
      stopLazyLoad();
      return;
    }

    orders.addAll(newItems);
    _calculateEdgeId();
  }

  void _calculateEdgeId(){
    _lowId = orders.first.id;
    for (var item in orders) {
      if(item.id < _lowId){
        _lowId = item.id;
      }
    }
  }

  @override
  void cleanData(){
    orders.clear();
  }
}
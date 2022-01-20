import 'package:carousel_slider/carousel_controller.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/di/location_service.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/base_controller/individual_screen_controller.dart';
import 'package:forwa_app/screens/take/take_screen_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class ProductScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductScreenController());
  }
}

enum ShareContentType {
  link
}

enum ShareMethod {
  copyToClipboard
}

class ProductScreenController extends IndividualScreenController {

  @override
  String get screenName => ROUTE_PRODUCT;

  final LocalStorage _localStorage = Get.find();

  final LocationService _locationService = Get.find();

  final ProductRepo _productRepo = Get.find();

  final Distance distance = Get.find();

  final current = 0.obs;
  final CarouselController sliderController = CarouselController();
  final images = List<String>.empty().obs;
  final sellerName = ''.obs;
  final name = ''.obs;
  final description = ''.obs;
  final createdAt = ''.obs;
  final pickupTime = ''.obs;
  final dueDate = ''.obs;
  final enabled = false.obs;
  final avatar = ''.obs;
  Position? here;

  set page(int index) => current.value = index;
  int get page => current.value;

  bool isNotificationStart = false;
  final int id = Get.arguments;
  late int? userId;

  LatLng? location;
  LatLng? wardLocation;

  @override
  void onInit() {
    super.onInit();
    if(Get.parameters[notificationStartParam] == NOTIFICATION_START_TRUE){
      isNotificationStart = true;
    }
  }

  @override
  Future onReady() async {
    super.onReady();

    here = await _locationService.here();

    showLoadingDialog();
    final response = await _productRepo.getProduct(id);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      return;
    }
    final product = response.data!;

    images.assignAll(product.images!.map((e) => resolveUrl(e.url, HOST_URL)));
    name.value = product.name;
    sellerName.value = product.sellerName!;
    description.value = product.description!;
    pickupTime.value = product.pickupTime!;
    createdAt.value = DateFormat('dd-MM-yyyy').format(product.createdAt!);
    enabled.value = product.enabled!;
    location = product.address?.location;
    wardLocation = product.address?.wardLocation;
    dueDate.value = product.dueDate != null
        ? DateFormat('dd-MM-yyyy').format(product.dueDate!)
        : '';
    userId = product.user?.id;
    avatar.value = product.user?.imageUrl ?? '';
  }

  void toTakeScreen(){
    final userId = _localStorage.getUserID();
    if(userId == null){
      showLoginDialog();
    } else {
      Get.toNamed(
        ROUTE_TAKE,
        parameters: {
          idParam: id.toString(),
          sellerNameParam: sellerName.value,
          notificationStartParam: isNotificationStart ? NOTIFICATION_START_TRUE : ''
        }
      );
    }
  }
}
import 'package:carousel_slider/carousel_controller.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/di/location_service.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/take/take_screen_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class ProductScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductScreenController());
  }
}

class ProductScreenController extends BaseController {

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
  LocationData? here;

  set page(int index) => current.value = index;
  int get page => current.value;

  final int id = Get.arguments;

  LatLng? location;
  LatLng? wardLocation;

  @override
  Future onReady() async {
    super.onReady();

    here = await _locationService.here();

    showLoadingDialog();
    final response = await _productRepo.getProduct(id);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      // TODO: show error popup
      return;
    }
    final product = response.data!;

    images.assignAll(product.images.map((e) => resolveUrl(e.url)));
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
        }
      );
    }
  }
}
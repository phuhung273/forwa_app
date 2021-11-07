import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/di/location_service.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../base_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());
  }
}

class HomeScreenController extends BaseController {

  final ProductRepo _productRepo = Get.find();

  final LocationService _locationService = Get.find();

  final products = List<Product>.empty().obs;

  final Distance distance = Get.find();

  LocationData? here;

  @override
  Future onReady() async {
    super.onReady();

    here = await _locationService.here();

    showLoadingDialog();
    final response = await _productRepo.getProductsOnWebsite();
    hideDialog();

    if(!response.isSuccess || response.data == null || response.data!.items == null){
      return;
    }

    products.assignAll(response.data!.items!);
  }
}
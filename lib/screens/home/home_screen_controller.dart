import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../base_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());
  }
}

class HomeScreenController extends BaseController {

  final ProductRepo _productRepo = Get.find();

  final products = List<Product>.empty().obs;

  @override
  Future onReady() async {
    super.onReady();

    showLoadingDialog();
    final response = await _productRepo.getProductsOnWebsite();
    hideDialog();

    if(!response.isSuccess || response.data == null || response.data!.items == null){
      return;
    }

    products.assignAll(response.data!.items!);
  }
}
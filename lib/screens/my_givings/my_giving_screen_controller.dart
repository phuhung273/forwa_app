import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/screens/base_controller.dart';
import 'package:get/get.dart';

class MyGivingsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyGivingsScreenController());
  }
}

class MyGivingsScreenController extends BaseController {

  final ProductRepo _productRepo = Get.find();

  final LocalStorage _localStorage = Get.find();

  final products = List<Product>.empty().obs;
  int? _websiteId;

  @override
  void onInit() {
    super.onInit();

    _websiteId = _localStorage.getStoreWebsiteId();
  }

  @override
  Future onReady() async {
    super.onReady();

    if(_websiteId == null) {
      showLoginDialog();
      return;
    }

    showLoadingDialog();
    final response = await _productRepo.getProductsOnWebsite(websiteId: _websiteId!);
    hideDialog();
    if(!response.isSuccess || response.data == null || response.data!.items == null){
      return;
    }

    products.assignAll(response.data!.items!);
  }
}
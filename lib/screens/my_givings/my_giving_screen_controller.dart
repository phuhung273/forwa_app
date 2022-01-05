import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/screens/base_controller/authorized_refreshable_controller.dart';
import 'package:get/get.dart';

class MyGivingsScreenController extends AuthorizedRefreshableController {

  final ProductRepo _productRepo = Get.find();

  final LocalStorage _localStorage = Get.find();

  final products = List<Product>.empty().obs;
  int? _userId;

  @override
  void onInit() {
    super.onInit();

    _userId = _localStorage.getUserID();
  }

  @override
  Future main() async {
    final response = await _productRepo.getMyProducts();

    if(!response.isSuccess || response.data == null){
      return;
    }

    products.assignAll(response.data!.items);
  }

  @override
  bool isAuthorized() {
    _userId = _localStorage.getUserID();
    return _userId != null;
  }
}
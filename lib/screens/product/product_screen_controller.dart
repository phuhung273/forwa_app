import 'package:carousel_slider/carousel_controller.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/screens/base_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductScreenController());
  }
}

class ProductScreenController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final ProductRepo _productRepo = Get.find();

  final current = 0.obs;
  final CarouselController sliderController = CarouselController();
  final images = List<String>.empty().obs;
  final sellerName = ''.obs;
  final name = ''.obs;
  final description = ''.obs;
  final createdAt = ''.obs;
  final pickupTime = ''.obs;
  final isDisabled = true.obs;

  bool _sameWebsiteId = true;

  bool get disableTakeButton => isDisabled.value || _sameWebsiteId;

  set page(int index) => current.value = index;
  int get page => current.value;

  final String sku = Get.arguments;

  @override
  Future onReady() async {
    super.onReady();

    if(sku.isEmpty) return;

    showLoadingDialog();
    final response = await _productRepo.getProduct(sku);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      // TODO: show error popup
      return;
    }
    final product = response.data!;

    images.assignAll(product.images!.map((e) => resolveUrl(e)));
    name.value = product.name;
    sellerName.value = product.sellerName!;
    description.value = product.description!;
    pickupTime.value = product.pickupTime!;
    createdAt.value = DateFormat.yMMMd().format(product.createdAt!);
    isDisabled.value = product.isDisabled;

    final websiteId = _localStorage.getStoreWebsiteId();
    _sameWebsiteId = websiteId == product.websiteId;
  }
}
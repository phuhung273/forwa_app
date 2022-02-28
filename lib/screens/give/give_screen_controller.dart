
import 'package:forwa_app/screens/base_screens/product_form/product_form_controller.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/schema/product/product_add.dart';
import 'package:forwa_app/screens/address_select/address_select_screen_controller.dart';
import 'package:forwa_app/screens/home/home_screen_controller.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class GiveScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GiveScreenController());
    Get.put(AddressSelectScreenController());
  }
}


const DEFAULT_PRODUCT_ADD_QUANTITY = 5;

class GiveScreenController extends ProductFormScreenController {

  final LocalStorage _localStorage = Get.find();

  final HomeScreenController _homeController = Get.find();

  final uuid = const Uuid();

  int? _userId;

  @override
  void onInit() {
    super.onInit();
    _userId = _localStorage.getUserID();
  }


  @override
  void onReady() async {
    super.onReady();
    if(_userId == null) Get.offAndToNamed(ROUTE_LOGIN);
  }


  @override
  Future submit() async {

    if(_userId == null) Get.offAndToNamed(ROUTE_LOGIN);

    if(imageFiles.isEmpty){
      showErrorDialog(message: errorCodeMap['PRODUCT_001']!);
      return;
    }

    final products = [
      ProductAdd(
        name: nameController.text,
        sku: uuid.v4(),
        description: descriptionController.text,
        quantity: DEFAULT_PRODUCT_ADD_QUANTITY,
        pickupTime: '$from - $to',
        images: imageFiles,
        dueDate: dueDate.isNotEmpty ? dueDate.value : null,
        addressId: addressSelectController.id.value
      )
    ];

    showLoadingDialog();
    final response = await productRepo.addProduct(products);
    hideDialog();
    if(!response.isSuccess || response.data == null){
      final message = errorCodeMap[response.statusCode] ?? 'Lỗi không xác định';
      showErrorDialog(message: message);
      return;
    }

    await showSuccessDialog(message: 'Thêm sản phẩm thành công');
    _homeController.products.insertAll(0, response.data?.items as Iterable<Product>);
    Get.back();
  }
}
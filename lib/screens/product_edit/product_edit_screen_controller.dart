
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/schema/product/product_update.dart';
import 'package:forwa_app/screens/address_select/address_select_screen_controller.dart';
import 'package:forwa_app/screens/base_controller/product_controller.dart';
import 'package:forwa_app/screens/base_screens/product_form/product_form_controller.dart';
import 'package:get/get.dart';

import '../../schema/image/image.dart';

class ProductEditScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductEditScreenController());
    Get.put(AddressSelectScreenController());
  }
}

class ProductEditScreenController extends ProductFormScreenController {

  final AddressSelectScreenController _addressSelectController = Get.find();

  final ProductController _productController = Get.find();

  final int _id = Get.arguments;

  final urlImages = List<Image>.empty().obs;

  deleteUrlImage(int index) {
    urlImages.removeAt(index);
  }

  @override
  void onReady() async {
    super.onReady();

    showLoadingDialog();
    final response = await productRepo.getProduct(_id);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      return;
    }
    final product = response.data!;

    urlImages.assignAll(product.images ?? []);
    nameController.text = product.name;
    descriptionController.text = product.description!;
    dueDate.value = product.dueDate?.toIso8601String() ?? '';

    final fromToStringList = product.pickupTime!.split(' - ');
    from.value = fromToStringList[0];
    to.value = fromToStringList[1];

    _addressSelectController.prefetchId = product.address!.id!;
  }

  @override
  Future submit() async {
    if(imageFiles.isEmpty && urlImages.isEmpty){
      showErrorDialog(message: errorCodeMap['PRODUCT_001']!);
      return;
    }

    final productUpdate = ProductUpdate(
      name: nameController.text,
      description: descriptionController.text,
      pickupTime: '$from - $to',
      addressId: _addressSelectController.id.value
    );

    if(imageFiles.isNotEmpty){
      productUpdate.imageFiles = imageFiles;
    }

    if(urlImages.isNotEmpty){
      productUpdate.imageIds = urlImages.map((element) => element.id).toList();
    }

    showLoadingDialog();
    final response = await productRepo.updateProduct(_id, productUpdate);
    hideDialog();
    if(!response.isSuccess || response.data == null){
      final message = errorCodeMap[response.statusCode] ?? 'L???i kh??ng x??c ?????nh';
      showErrorDialog(message: message);
      return;
    }

    _productController.emitEditProductEvent(response.data!);
    await showSuccessDialog(message: 'Ch???nh s???a th??nh c??ng');
    Get.back();
  }
}
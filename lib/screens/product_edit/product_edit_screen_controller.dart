
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/schema/product/product_update.dart';
import 'package:forwa_app/screens/address_select/address_select_screen_controller.dart';
import 'package:forwa_app/screens/base_screens/product_form/product_form_controller.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../helpers/url_helper.dart';

class ProductEditScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductEditScreenController());
    Get.put(AddressSelectScreenController());
  }
}

class ProductEditScreenController extends ProductFormScreenController {

  final AddressSelectScreenController _addressSelectController = Get.find();

  final int _id = Get.arguments;

  final urls = List<String>.empty().obs;

  deleteUrlImage(int index) {
    urls.removeAt(index);
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

    urls.assignAll(product.images!.map((e) => resolveUrl(e.url, HOST_URL)));
    nameController.text = product.name;
    descriptionController.text = product.description!;
    dueDate.value = product.dueDate?.toIso8601String() ?? '';

    final fromToStringList = product.pickupTime!.split(' - ');
    from.value = fromToStringList[0];
    to.value = fromToStringList[1];

    _addressSelectController.id.value = product.address!.id!;
  }

  @override
  Future submit() async {
    if(imageFiles.isEmpty && urls.isEmpty){
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

    if(urls.isNotEmpty){
      productUpdate.imageUrls = urls;
    }

    showLoadingDialog();
    final response = await productRepo.updateProduct(_id, productUpdate);
    hideDialog();
    if(!response.isSuccess || response.data == null){
      final message = errorCodeMap[response.statusCode] ?? 'Lỗi không xác định';
      showErrorDialog(message: message);
      return;
    }

    await showSuccessDialog(message: 'Chỉnh sửa thành công');
  }
}
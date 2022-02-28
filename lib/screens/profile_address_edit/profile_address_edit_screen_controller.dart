import 'package:forwa_app/datasource/repository/address_repo.dart';
import 'package:get/get.dart';

import '../../schema/address/address.dart';
import '../base_screens/address_form/address_form_controller.dart';

class ProfileAddressEditScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileAddressEditScreenController());
  }
}

class ProfileAddressEditScreenController extends AddressFormScreenController {

  final AddressRepo _addressRepo = Get.find();

  static const idParam = 'id';
  static const textParam = 'text';
  static const phoneParam = 'phone';

  late int _id;

  @override
  void onInit() {
    super.onInit();

    _id = int.tryParse(Get.parameters[idParam]!)!;
    phoneController.text = Get.parameters[phoneParam]!;
    addressController.text = Get.parameters[textParam]!;
  }

  @override
  Future save() async {
    showLoadingDialog();

    final addressRequest = Address(
      phone: phoneController.text
    );

    if(detailsResult != null){
      final location = detailsResult!.geometry!.location!;
      addressRequest.text = detailsResult!.formattedAddress;
      addressRequest.latitude = location.lat.toString();
      addressRequest.latitude = location.lng.toString();
    }

    final response = await _addressRepo.updateAddress(_id, addressRequest);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      // TODO: show error popup
      return;
    }

    await showSuccessDialog(message: 'Chỉnh sửa thành công');

    final address = response.data!;
  }
}
import 'package:flutter/cupertino.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/address_repo.dart';
import 'package:forwa_app/schema/address/address.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/profile_address/profile_address_screen_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class EditProfileAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileAddressController());
  }
}

class EditProfileAddressController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final AddressRepo _addressRepo = Get.find();

  final ProfileAddressScreenController _profileAddressController = Get.find();

  final streetController = TextEditingController();
  final wardController = TextEditingController();
  final districtController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();

  String? _name;

  @override
  void onInit() {
    super.onInit();

    _name = _localStorage.getCustomerName();

    if(_name == null){
      return;
    }
  }

  Future save() async {
    if(_name == null){
      // TODO: add error text
      return;
    }

    List<Location> locations = await locationFromAddress(streetController.text + wardController.text + districtController.text + cityController.text);
    final location = locations.first;
    List<Location> wardLocations = await locationFromAddress(wardController.text + districtController.text + cityController.text);
    final wardLocation = wardLocations.first;

    final address = Address(
      street: streetController.text,
      ward: wardController.text,
      district: districtController.text,
      city: cityController.text,
      name: _name!,
      phone: phoneController.text,
      isDefault: true,
      latitude: location.latitude.toString(),
      longitude: location.longitude.toString(),
      wardLatitude: wardLocation.latitude.toString(),
      wardLongitude: wardLocation.longitude.toString(),
    );

    showLoadingDialog();
    final response = await _addressRepo.saveAddress(address);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      // TODO: show error popup
      return;
    }

    await showSuccessDialog(message: 'Thêm địa chỉ thành công');

    _profileAddressController.addresses.add(address);
    Get.back();
  }
}